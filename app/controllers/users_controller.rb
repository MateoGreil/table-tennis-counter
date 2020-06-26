class UsersController < InheritedResources::Base
  actions :all, except: :index

  PARAMS_ORDER_BY = %w[login games_w games_l games_w_l matches_w matches_l
                       matches_w_l total_points average_points].freeze
  PARAMS_DIRECTION = %w[ASC DESC].freeze

  def index
    order_by = params[:order_by] if params[:order_by].in?(PARAMS_ORDER_BY)
    direction = if params[:direction].in?(PARAMS_DIRECTION)
                  params[:direction]
                else
                  ''
                end
    @collection = ActiveRecord::Base.connection.execute(
      <<-SQL
        SELECT login,
          COUNT(games_w) AS games_w,
          COUNT(games_l) AS games_l,
          round(COUNT(games_w)::decimal / (NULLIF(COUNT(games_l), 0)), 3) AS games_w_l,
          COUNT(DISTINCT matches_w) AS matches_w,
          COUNT(DISTINCT matches_l) AS matches_l,
          round(COUNT(DISTINCT matches_w)::decimal / (NULLIF(COUNT(DISTINCT matches_l), 0)), 3) AS matches_w_l,
          SUM(COALESCE(games_f.first_team_points, 0) + COALESCE(games_s.second_team_points, 0)) AS total_points,
          round(AVG(COALESCE(games_f.first_team_points, 0) + COALESCE(games_s.second_team_points, 0)), 3) AS average_points
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
        GROUP BY users.id
        #{order_by ? 'ORDER BY ' + order_by + ' ' + direction : ''};
      SQL
    )
  end

  private

  def resource
    User.friendly.find(params[:id])
  end
end
