defmodule StattleshipEx.MLB do
  @moduledoc """
  Stattleship MLB Feeds

  Doesn't support `play_by_play` use At Bats and Pitches

  http://developers.stattleship.com

  Stattleship supports the `link` header.
  If you want to fetch all pages of a resource pass `fetch_all: true` and
  it will grab all pages then merge the results together. Sorting may not be
  correct when fetching all pages.
  """

  alias StattleshipEx

  @doc """

  slug = "nfl-2018-2019-ne-la-2019-02-3-1830"
  {:ok, %{body: games}} = StattleshipEx.MLB.games(on: "today")
  {:ok, %{body: games}} = StattleshipEx.MLB.games(fetch_all: true)
  {:ok, %{body: games}} = StattleshipEx.MLB.games(status: 'in-progress,postgame-reviewing')
  {:ok, %{body: games}} = StattleshipEx.MLB.games(team_id: "nfl-gs")
  {:ok, %{body: games}} = StattleshipEx.MLB.games(team_id: "nfl-gs")

  When fetching all games they won't be in order
  Enum.sort(games2["games"], fn(one, two) -> one["timestamp"]<two["timestamp"] end) |> hd

  Query Params:

  per_page 20 Items per page with maximum of 40.
  page  Page of results
  player_id  Player slug such as nfl-lebron-james for Lebron James
  team_id  Team slug such as nfl-gs for the Warriors
  official_id  Official slug from the Official endpoint to fetch games officiated by. Optional.
  interval_type regularseason See interval_type for sport.
  season_id Current season Season slug such as nfl-2015-2016
  on  Friendly date such as today or tomorrow; or a timestamp; or a date such as 2016-05-22
  since  Friendly date such as 1 week ago or 4 days ago or last Sunday; or a timestamp such as 1448820000
  status  Game status of in_progress upcoming or ended
  id  If you want a single game

  """
  def games(query \\ []) do
    StattleshipEx.get("/baseball/mlb/games", query: query)
  end

  @doc """
  "lineups": [
    {
      "id": "f16be366-f4d6-420d-b248-78a30d15c643",
      "created_at": "2017-02-25T15:17:28-05:00",
      "updated_at": "2017-02-25T15:17:28-05:00",
      "inning": 0,
      "inning_half": null,
      "batting_order": 1,
      "lineup_position": 4,
      "position_name": "Second Base",
      "position_abbreviation": "2B",
      "sequence": 1,
      "game_id": "9bc002ce-e03e-414b-8dd7-c74613720a22",
      "player_id": "5975f524-391f-45bd-ac47-e84f3bbba27f",
      "team_id": "0644a90f-96ca-4d20-b83a-a6008462f89c"
    },
  ]

  Query Params:

  * `per_page` 20 Items per page with maximum of 40. Teams
  * `page` Page of results
  * `season_id` Current season
  """
  def lineups(query \\ []) do
    StattleshipEx.get("/baseball/mlb/lineups", query: query)
  end

  @doc """

  Query Params:

  * `per_page` 20 Items per page with maximum of 40. Teams
  * `page` Page of results
  * `season_id` Current season
  """
  def probable_pitchers(query \\ []) do
    StattleshipEx.get("/baseball/mlb/probable_pitchers", query: query)
  end

  @doc """

  Query Params:

  * `per_page` 20 Items per page with maximum of 40. Teams
  * `page` Page of results
  * `season_id` Current season
  """
  def starting_pitchers(query \\ []) do
    StattleshipEx.get("/baseball/mlb/starting_pitchers", query: query)
  end

  @doc """

  Query Params:

  * `per_page` 20 - Items per page with maximum of 40. Teams
  * `page` Page of results
  * `game_id` Game slug such as mlb-2017-cin-kc-2017-03-20-1605 for Reds vs Royals
  * `season_id	Current season	Season slug such as mlb-2016
  * `team_id` Team slug such as mlb-tor
  * `player_id` Player slug such as mlb-aroldis-chapman
  * `interval_type	current interval	See interval_type for sport.
  * `on` Friendly date such as today or tomorrow; or a timestamp; or a date such as 2016-05-22
  * `hit_location` Number 1-35.
  * `hit_type` FB, GB, LD, PU
  * `hitter_id` Slug of the hitter, like mlb-david-ortiz
  * `hitter_team_id` Slug of the hitting team, like mlb-bos
  * `inning` Number
  * `pitch_outcome_type` Fetch using https://api.stattleship.com/baseball/mlb/pitch_outcome_types
  * `pitch_type` CH, CT, CU, FA, FO, IB, KN, PI, SC, SI, SL, SP
  * `pitcher_id` Slug of the pitcher, like mlb-aroldis-chapman
  * `team_id` Slug of the pitching team, like mlb-bos
  """
  def pitches(query \\ []) do
    StattleshipEx.get("/baseball/mlb/pitches", query: query)
  end

  @doc """
  Fetches game stats for players. Can find by game, player, date, etc.

  ## Examples:

      game_id = "nfl-2018-2019-ne-la-2019-02-3-1830"
      {:ok, %{body: games}} = StattleshipEx.MLB.play_by_play(game_id: game_id, week: 2)
      {:ok, %{body: games}} = StattleshipEx.MLB.play_by_play(week: 16, fetch_all: true)

  ## Query Params:

  * `per_page` 20 Items per page with maximum of 40. Teams
  * `page` Page of results
  * `game_id` Game slug such as nfl-2015-2016-nyg-min-2015-12-27-2030 for Giants vs Vikings
  * `player_id` Player slug such as nfl-tom-brady
  * `team_id` Team slug such as nfl-ne for the Patriots
  * `interval_type` Either Seeinterval_type` for sport.
  * `season_id` Current season Season slug such as nfl-2015-2016
  * `on` Friendly date such as today or tomorrow; or a timestamp; or a date such as 2016-05-22
  * `since` Friendly date such as 1 week ago or 4 days ago or last Sunday; or a timestamp such as 1448820000
  * `week` For NFL its week number such as 6
  * `status` Game status of in_progress upcoming or ended
  """
  def game_logs(query \\ []) do
    StattleshipEx.get("/baseball/mlb/game_logs", query: query)
  end

  @doc """
  Docs say this is an unsupported sport but it seems to work fine.

  ## Query Params:

  * `per_page` 20 Items per page with maximum of 40.
  * `page` Page of results
  """
  def scoring_plays(query \\ []) do
    StattleshipEx.get("/baseball/mlb/scoring_plays", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  """
  def teams(query \\ []) do
    StattleshipEx.get("/baseball/mlb/teams", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  game_id  Game slug such as nfl-2015-2016-chi-dal-2015-12-26-2030 for Bulls vs Mavericks
  player_id  Player slug such as nfl-lebron-james for Lebron James
  team_id  Team slug such as nfl-gs for the Warriors
  interval_type current interval See interval_type for sport.
  on  Friendly date such as today or tomorrow; or a timestamp; or a date such as 2016-05-22
  since  Friendly date such as 1 week ago or 4 days ago or last Sunday; or a timestamp such as 1448820000
  season_id Current season Season slug such as nfl-2015-2016
  level  Feats have levels 0 to 5 where 0 is typical and 3 is rare and 5 is new record
  name  The stat name for the feat
  """
  def feats(query \\ []) do
    StattleshipEx.get("/baseball/mlb/feats", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  season_id Current season Season slug such as nfl-2015-2016
  """
  def injuries(query \\ []) do
    StattleshipEx.get("/baseball/mlb/injuries", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  official_slug  Optional. Slug id of a single official to fetch
  official_roles  Optional role like official, etc. See Official Roles per League above.
  """
  def officials(query \\ []) do
    StattleshipEx.get("/baseball/mlb/officials", query: query)
  end

  @doc """
  # per_page 20 Items per page with maximum of 40.
  # page  Page of results
  # team_id  Team slug such as nfl-gs for the Warriors
  # birth_date  Date
  """
  def players(query \\ []) do
    StattleshipEx.get("/baseball/mlb/players", query: query)
  end

  # per_page 20 Items per page with maximum of 40.
  # page  Page of results
  # season_id Current season Season slug such as nfl-2016-2017
  # team_id  Team slug such as nfl-cle
  # player_id  Player slug such as nfl-lebron-james
  # interval_type current interval See interval_type for sport.
  # on  Friendly date such as today or tomorrow; or a timestamp; or a date such as 2016-10-25
  def player_season_stats(query \\ []) do
    StattleshipEx.get("/baseball/mlb/player_season_stats", query: query)
  end

  # per_page 20 Items per page with maximum of 40.
  # page  Page of results
  # ranking  See link above for a list of available rankings
  # on  Date for a daily ranking
  # since  Friendly date such as 1 week ago or 4 days ago or last Sunday
  def rankings(query \\ []) do
    StattleshipEx.get("/baseball/mlb/rankings", query: query)
  end

  # per_page 20 Items per page with maximum of 40.
  # page  Page of results
  # team_id  Team slug such as nfl-ny for the Knicks
  # season_id Current season Season slug such as nfl-2015-2016
  def rosters(query \\ []) do
    StattleshipEx.get("/baseball/mlb/rosters", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  game_id  Optional. Game slug.
  team_id  Optional. Team slug such as nfl-bos for the Celtics
  interval_type regularseason See interval_type for sport.
  on  Friendly date such as today or tomorrow; or a timestamp; or a date such as 2017-04-22
  since  Friendly date such as 1 week ago or 4 days ago or last Sunday; or a timestamp such as 1448820000
  season_id Current season Season slug such as nfl-2016-2017
  status  Optional. One of canceled
  """
  def scoreboards(query \\ []) do
    StattleshipEx.get("/baseball/mlb/scoreboards", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  """
  def seasons(query \\ []) do
    StattleshipEx.get("/baseball/mlb/seasons", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  team_id  Team slug such as nfl-dal
  game_id  Game slug such as nfl-2015-2016-chi-dal-2015-12-26-2030
  interval_type current interval See interval_type for sport.
  on  Friendly date such as today or tomorrow; or a timestamp; or a date such as 2016-05-22
  since  Friendly date such as 1 week ago or 4 days ago or last Sunday; or a timestamp such as 1448820000
  season_id Current season Season slug such as nfl-2015-2016
  status  Game status of in_progress upcoming or ended
  """
  def team_game_logs(query \\ []) do
    StattleshipEx.get("/baseball/mlb/team_game_logs", query: query)
  end

  @doc """
  per_page 20 Items per page with maximum of 40.
  page  Page of results
  season_id Current season Season slug such as nfl-2015-2016
  team_id  Team slug such as nfl-gs
  interval_type current interval See interval_type for sport.
  streak_length  Length of the streak
  rank  nth longest ranked streak
  ranked  Streaks ranked nth or higher
  outcome  Supports win or loss. Unspecified returns all.
  current  If you want the current streak
  """
  def team_outcome_streaks(query \\ []) do
    StattleshipEx.get("/baseball/mlb/team_outcome_streaks", query: query)
  end
end
