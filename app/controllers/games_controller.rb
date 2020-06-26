class GamesController < InheritedResources::Base
  actions :all, except: :show
  load_and_authorize_resource

  def new
    resource ||= build_resource
    resource.first_team = Team.new if resource.second_team.nil?
    resource.second_team = Team.new if resource.second_team.nil?
    super
  end

  private

  def game_params
    params.require(:game).permit(
      :rule,
      :first_team_points,
      :second_team_points,
      first_team_attributes: [
        :id,
        team_users_attributes: [
          :id,
          :_destroy,
          :user_id
        ]
      ],
      second_team_attributes: [
        :id,
        team_users_attributes: [
          :id,
          :_destroy,
          :user_id
        ]
      ]
    )
  end
end
