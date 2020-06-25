class UsersController < InheritedResources::Base
  actions :all, except: :index

  def index
    @collection = ActiveRecord::Base.connection.execute(
      <<-SQL
        SELECT users.login,
          COUNT(games_w) AS games_w,
          COUNT(games_l) AS games_l,
          round(COUNT(games_w)::decimal / (NULLIF(COUNT(games_l), 0)), 3) AS games_w_l
        FROM users
        LEFT OUTER JOIN team_users ON team_users.user_id = users.id
        LEFT OUTER JOIN teams ON team_users.team_id = teams.id
        LEFT OUTER JOIN games AS games_w
          ON (games_w.t_one_id = teams.id AND games_w.winner = FALSE)
          OR (games_w.t_two_id = teams.id AND games_w.winner = TRUE)
        LEFT OUTER JOIN games AS games_l
          ON (games_l.t_one_id = teams.id AND games_l.winner = TRUE)
          OR (games_l.t_two_id = teams.id AND games_l.winner = FALSE)
        GROUP BY users.id;
      SQL
    )
  end
end
