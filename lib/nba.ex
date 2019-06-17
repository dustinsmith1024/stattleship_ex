defmodule StattleshipEx.NBA do
  @moduledoc """
  Stattleship NBA Feeds

  http://developers.stattleship.com

  Stattleship supports the `link` header.
  If you want to fetch all pages of a resource pass `fetch_all: true` and
  it will grab all pages then merge the results together. Sorting may not be
  correct when fetching all pages.
  """

  alias StattleshipEx

  @doc """

  slug = "nba-2018-2019-gs-tor-2019-06-2-2000"
  {:ok, %{body: games}} = StattleshipEx.NBA.games(on: "today")
  {:ok, %{body: games}} = StattleshipEx.NBA.games(fetch_all: true)
  {:ok, %{body: games}} = StattleshipEx.NBA.games(status: 'in-progress,postgame-reviewing')
  {:ok, %{body: games}} = StattleshipEx.NBA.games(team_id: "nba-gs")
  {:ok, %{body: games}} = StattleshipEx.NBA.games(team_id: "nba-gs")

  When fetching all games they won't be in order
  Enum.sort(games2["games"], fn(one, two) -> one["timestamp"]<two["timestamp"] end) |> hd

  Query Params:

  per_page 20 Items per page with maximum of 40.
  page  Page of results
  player_id  Player slug such as nba-lebron-james for Lebron James
  team_id  Team slug such as nba-gs for the Warriors
  official_id  Official slug from the Official endpoint to fetch games officiated by. Optional.
  interval_type regularseason See interval_type for sport.
  season_id Current season Season slug such as nba-2015-2016
  on  Friendly date such as today or tomorrow; or a timestamp; or a date such as 2016-05-22
  since  Friendly date such as 1 week ago or 4 days ago or last Sunday; or a timestamp such as 1448820000
  status  Game status of in_progress upcoming or ended
  id  If you want a single game

  """
  def games(query \\ []) do
    StattleshipEx.get("/basketball/nba/games", query: query)
  end

  @doc """
  Fetches game stats for players. Can find by game, player, date, etc.

  ## Examples:

      slug = "nba-2018-2019-gs-tor-2019-06-2-2000"
      {:ok, %{body: games}} = StattleshipEx.NBA.play_by_play(slug, quarter: 2)
      {:ok, %{body: games}} = StattleshipEx.NBA.play_by_play(slug, quarter: 4, fetch_all: true)

  ## Query Params:

  * `per_page` 20 Items per page with maximum of 40.
  * `game_id` Game slug such as nba-2015-2016-chi-dal-2015-12-26-2030 for Bulls vs Mavericks
  * `player_id` Player slug such as nba-lebron-james for Lebron James
  * `team_id` Team slug such as nba-gs for the Warriors
  * `interval_type` regularseason See interval_type for sport.
  * `on` Friendly date such as today or tomorrow; or a timestamp; or a date such as 2016-05-22
  * `since` Friendly date such as 1 week ago or 4 days ago or last Sunday; or a timestamp such as 1448820000
  * `season_id` Current season Season slug such as nba-2015-2016
  * `status` Game status of in_progress upcoming or ended
  """
  def game_logs(query \\ []) do
    StattleshipEx.get("/basketball/nba/game_logs", query: query)
  end

  @doc """
  Fetch play by play data for a game.

  ## Examples:

      slug = "nba-2018-2019-gs-tor-2019-06-2-2000"
      {:ok, %{body: games}} = StattleshipEx.NBA.play_by_play(slug, quarter: 2)
      {:ok, %{body: games}} = StattleshipEx.NBA.play_by_play(slug, quarter: 4, fetch_all: true)

  ## Query params:

  * `per_page` 20 Items per page with maximum of 40.
  * `page`  Page of results
  * id  Required game slug as a resource, ie play_by_play/nba-2016-2017-pho-lac-2016-10-31-1930
  * `quarter`  Number
  * `team_id`  Team slug such as nba-bos for the Celtics.
  * `event_type`  Filter by a type of play. See Basketball Play by Play Event Types above.
  * `include_stats`  Optional. If present will return stats per player involved in play, such as who made the shot and who got the assist.
  * `include_on_court`  Optional. If present will return every player on the court for the play.
  * `per_page`  You can request up to 100 per page
  """
  def play_by_play(game_slug, query \\ []) do
    StattleshipEx.get("/basketball/nba/play_by_play/#{game_slug}", query: query)
  end

  @doc """
  Docs say this is an unsupported sport but it seems to work fine.

  ## Query Params:

  * `per_page` 20 Items per page with maximum of 40.
  * `page` Page of results
  """
  def scoring_plays(query \\ []) do
    StattleshipEx.get("/basketball/nba/scoring_plays", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  """
  def teams(query \\ []) do
    StattleshipEx.get("/basketball/nba/teams", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  game_id  Game slug such as nba-2015-2016-chi-dal-2015-12-26-2030 for Bulls vs Mavericks
  player_id  Player slug such as nba-lebron-james for Lebron James
  team_id  Team slug such as nba-gs for the Warriors
  interval_type current interval See interval_type for sport.
  on  Friendly date such as today or tomorrow; or a timestamp; or a date such as 2016-05-22
  since  Friendly date such as 1 week ago or 4 days ago or last Sunday; or a timestamp such as 1448820000
  season_id Current season Season slug such as nba-2015-2016
  level  Feats have levels 0 to 5 where 0 is typical and 3 is rare and 5 is new record
  name  The stat name for the feat
  """
  def feats(query \\ []) do
    StattleshipEx.get("/basketball/nba/feats", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  season_id Current season Season slug such as nba-2015-2016
  """
  def injuries(query \\ []) do
    StattleshipEx.get("/basketball/nba/injuries", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  official_slug  Optional. Slug id of a single official to fetch
  official_roles  Optional role like official, etc. See Official Roles per League above.
  """
  def officials(query \\ []) do
    StattleshipEx.get("/basketball/nba/officials", query: query)
  end

  @doc """
  # per_page 20 Items per page with maximum of 40.
  # page  Page of results
  # team_id  Team slug such as nba-gs for the Warriors
  # birth_date  Date
  """
  def players(query \\ []) do
    StattleshipEx.get("/basketball/nba/players", query: query)
  end

  # per_page 20 Items per page with maximum of 40.
  # page  Page of results
  # season_id Current season Season slug such as nba-2016-2017
  # team_id  Team slug such as nba-cle
  # player_id  Player slug such as nba-lebron-james
  # interval_type current interval See interval_type for sport.
  # on  Friendly date such as today or tomorrow; or a timestamp; or a date such as 2016-10-25
  def player_season_stats(query \\ []) do
    StattleshipEx.get("/basketball/nba/player_season_stats", query: query)
  end

  # per_page 20 Items per page with maximum of 40.
  # page  Page of results
  # ranking  See link above for a list of available rankings
  # on  Date for a daily ranking
  # since  Friendly date such as 1 week ago or 4 days ago or last Sunday
  def rankings(query \\ []) do
    StattleshipEx.get("/basketball/nba/rankings", query: query)
  end

  # per_page 20 Items per page with maximum of 40.
  # page  Page of results
  # team_id  Team slug such as nba-ny for the Knicks
  # season_id Current season Season slug such as nba-2015-2016
  def rosters(query \\ []) do
    StattleshipEx.get("/basketball/nba/rosters", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  game_id  Optional. Game slug.
  team_id  Optional. Team slug such as nba-bos for the Celtics
  interval_type regularseason See interval_type for sport.
  on  Friendly date such as today or tomorrow; or a timestamp; or a date such as 2017-04-22
  since  Friendly date such as 1 week ago or 4 days ago or last Sunday; or a timestamp such as 1448820000
  season_id Current season Season slug such as nba-2016-2017
  status  Optional. One of canceled
  """
  def scoreboards(query \\ []) do
    StattleshipEx.get("/basketball/nba/scoreboards", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  """
  def seasons(query \\ []) do
    StattleshipEx.get("/basketball/nba/seasons", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  team_id  Team slug such as nba-dal
  game_id  Game slug such as nba-2015-2016-chi-dal-2015-12-26-2030
  interval_type current interval See interval_type for sport.
  on  Friendly date such as today or tomorrow; or a timestamp; or a date such as 2016-05-22
  since  Friendly date such as 1 week ago or 4 days ago or last Sunday; or a timestamp such as 1448820000
  season_id Current season Season slug such as nba-2015-2016
  status  Game status of in_progress upcoming or ended
  """
  def team_game_logs(query \\ []) do
    StattleshipEx.get("/basketball/nba/team_game_logs", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  season_id Current season Season slug such as nba-2015-2016
  team_id  Team slug such as nba-gs
  interval_type current interval See interval_type for sport.
  streak_length  Length of the streak
  rank  nth longest ranked streak
  ranked  Streaks ranked nth or higher
  outcome  Supports win or loss. Unspecified returns all.
  current  If you want the current streak
  """
  def team_outcome_streaks(query \\ []) do
    StattleshipEx.get("/basketball/nba/team_outcome_streaks", query: query)
  end
end
