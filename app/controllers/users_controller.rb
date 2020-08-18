class UsersController < InheritedResources::Base
  load_and_authorize_resource
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
          COUNT(DISTINCT games_w) AS games_w,
          COUNT(DISTINCT games_l) AS games_l,
          round(COUNT(DISTINCT games_w)::decimal / NULLIF(COUNT(DISTINCT games_l) + COUNT(DISTINCT games_w), 0), 3) AS games_w_l,
          COUNT(DISTINCT matches_w) AS matches_w,
          COUNT(DISTINCT matches_l) AS matches_l,
          round(COUNT(DISTINCT matches_w)::decimal / (NULLIF(COUNT(DISTINCT matches_l) + COUNT(DISTINCT matches_w), 0)), 3) AS matches_w_l,
          COALESCE(SUM(DISTINCT games_f.first_team_points), 0) + COALESCE(SUM(DISTINCT games_s.second_team_points), 0) AS total_points,
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
          AND games_l.winner_id IS NOT NULL
        LEFT OUTER JOIN matches AS matches_w
          ON matches_w.winner_id = teams.id
        LEFT OUTER JOIN matches AS matches_l
          ON (matches_l.first_team_id = teams.id 
          OR matches_l.second_team_id = teams.id)
          AND matches_l.winner_id != teams.id
          AND matches_l.winner_id IS NOT NULL
        LEFT OUTER JOIN games AS games_f
          ON games_f.first_team_id = teams.id
          AND games_f.winner_id IS NOT NULL
        LEFT OUTER JOIN games AS games_s
          ON games_s.second_team_id = teams.id
          AND games_s.winner_id IS NOT NULL
        GROUP BY users.id
        #{order_by ? 'ORDER BY ' + order_by + ' ' + direction : ''};
      SQL
    )
  end

  def show
    super
    @enemy = []
  end

  def rivalry
    @first_user = User.find_by(slug: params[:user1])
    @second_user = User.find_by(slug: params[:user2])
    @games = Game.where(id: Game.from_user(@first_user)).where(id: Game.from_user(@second_user))
    @first_user_games_wins = @games.from_winner(@first_user).count
    @second_user_games_wins = @games.from_winner(@second_user).count
  end

  private

  def resource
    @user ||= end_of_association_chain.find_by_slug!(params[:slug])
  end

end
