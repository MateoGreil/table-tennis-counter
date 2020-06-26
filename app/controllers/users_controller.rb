class UsersController < InheritedResources::Base
  actions :all, except: :index

  def index
    @collection = ActiveRecord::Base.connection.execute(
      <<-SQL
        SELECT users.login,
          COUNT(teams.id) AS teams,
          COUNT(games_w) AS games_w,
          COUNT(games_l) AS games_l,
          round(COUNT(games_w)::decimal / (NULLIF(COUNT(games_l), 0)), 3) AS games_w_l,
          COUNT(DISTINCT matches_w) AS matches_w,
          COUNT(DISTINCT matches_l) AS matches_l,
          round(COUNT(DISTINCT matches_w)::decimal / (NULLIF(COUNT(DISTINCT matches_l), 0)), 3) AS matches_w_l,
          (SUM(games_f.first_team_points) + SUM(games_s.second_team_points)) AS total_team_points
        FROM users
        LEFT OUTER JOIN team_users ON team_users.user_id = users.id
        LEFT OUTER JOIN teams ON team_users.team_id = teams.id
        LEFT OUTER JOIN games AS games_w
          ON games_w.winner_id = teams.id
        LEFT OUTER JOIN games AS games_l
          ON (games_l.first_team_id = teams.id 
          OR games_l.second_team_id = teams.id)
          AND games_l.winner_id != teams.id
        LEFT OUTER JOIN matches AS matches_w
          ON matches_w.winner_id = teams.id
        LEFT OUTER JOIN matches AS matches_l
          ON (matches_l.first_team_id = teams.id 
          OR matches_l.second_team_id = teams.id)
          AND matches_l.winner_id != teams.id
        LEFT OUTER JOIN games AS games_f
          ON games_f.first_team_id = teams.id
        LEFT OUTER JOIN games AS games_s
          ON games_s.second_team_id = teams.id
        GROUP BY users.id;
      SQL
    )
  end
end
