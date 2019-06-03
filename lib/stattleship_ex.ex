defmodule StattleshipEx do
  @moduledoc """
  My Sports Feeds client

  iex(8)> r = Stattleship.get("/basketball/nba/games", [on: today])
  iex(8)> {:ok, %{body: b}} = r
  iex(11)> {:ok, %{status: s}} = r
  """
  require Logger

  def get(path, opts \\ []) when is_list(opts) do

    opts
    |> api_key()
    |> client()
    |> Tesla.get(path, Keyword.take(opts, [:query]))
    |> parse_response()
    |> return_or_more(opts)
  end

  def return_or_more({:error} = r, _opts), do: r

  # User requested more than one page
  # Use the query param is not ideal...
  # Sorting may be off here too
  def return_or_more(r, opts) do
    # [query: [fetch_all: true]] =
    case Keyword.get(opts[:query], :fetch_all) do
      true ->
        all = check_for_more([r], opts)

        Enum.reduce(all, {:ok, %{body: %{}}}, fn {:ok, %{body: body}}, {:ok, %{body: acc}} ->
          # Third arg to map allows you to fix conflicts
          # Map.merge(%{games: [1,2,3,66]}, %{games: [2,3,4,5]}, fn(_k, one, two) -> Enum.uniq(one ++ two) end)
          {:ok,
          %{
            body:
              Map.merge(acc, body, fn _key, one, two ->
                # This would fail if somehow the keys were not the same type
                # uniq may be unnecessary, but just in case
                Enum.uniq(one ++ two)
              end)
          }}
        end)
      _ ->
        Logger.debug("We dont want more")
        r
    end
  end

  defp check_for_more([{:error, _} | _tail] = r, _opts), do: r

  defp check_for_more(
         [{:ok, %{body: _body, headers: headers, status: _status}} | _tail] = res,
         opts
       ) do
    link_header = Enum.find(headers, fn h -> elem(h, 0) == "link" end)
    parsed_links = ExLinkHeader.parse!(elem(link_header, 1))

    case parsed_links.next do
      nil ->
        Logger.debug("No more pages to get.")
        res

      %ExLinkHeaderEntry{url: url} ->
        Logger.debug("Go get another page #{url}")

        more =
          api_key(opts)
          |> client()
          |> Tesla.get(url, Keyword.take(opts, [:query]))
          |> parse_response()

        check_for_more([more | res], opts)
    end
  end

  defp parse_response({:ok, %{body: body, headers: headers, status: status}}) do
    case status do
      200 ->
        {:ok, %{body: body, headers: headers, status: status}}

      # 500, 400, 404 are common
      _ ->
        {:error, %{body: body, headers: headers, status: status}}
    end
  end

  defp parse_response({:error, error}) do
    {:error, %{error: error, body: "Something went wrong in the client."}}
  end

  def client(token) when token != nil do
    middleware = [
      Tesla.Middleware.Logger,
      {Tesla.Middleware.BaseUrl, "https://api.stattleship.com"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         {"Authorization", "Token token=" <> token},
         {"Accept", "application/vnd.stattleship.com; version=1"}
       ]}
    ]

    Tesla.client(middleware)
  end

  defp api_key(opts) do
    # this option probably wont be used
    api_key =
      Keyword.get(opts[:query], :api_key) ||
        Keyword.get(opts, :api_key) ||
        config_key()

    unless api_key do
      raise RuntimeError, """
      No API key found for My Sports Feeds.
      Pass `api_key` in with the options or set it in config

      StattleshipEx.NBA.games(api_key: "API_KEY")

      config :stattleship_ex,
        api_key: "your_token"

      config :stattleship_ex,
        api_key: {:system, "STATTLESHIP_API_KEY"}
      """
    end

    api_key
  end

  defp config_key do
    case Application.get_env(:stat, :api_key) do
      # Grabs the name you configured out of ENV
      {:system, env_key} ->
        IO.puts(env_key)

        case System.get_env(env_key) do
          nil -> raise RuntimeError, "ENV Variable not set correctly"
          "" -> raise RuntimeError, "ENV Variable not set correctly"
          # the real key
          k -> k
        end

      nil ->
        System.get_env("STATTLESHIP_API_KEY")

      key ->
        key
    end
  end
end
