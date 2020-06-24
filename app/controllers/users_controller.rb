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
          ON teams.status = #{Team.statuses[:winner]}
          AND teams.teamable_id = games_w.id
          AND teams.teamable_type = 'Game'
        LEFT OUTER JOIN games AS games_l
          ON teams.status = #{Team.statuses[:looser]}
          AND teams.teamable_id = games_l.id
          AND teams.teamable_type = 'Game'
        GROUP BY users.id;
      SQL
    )
  end
end
