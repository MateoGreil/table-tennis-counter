class MatchesController < InheritedResources::Base

  def new
    resource ||= build_resource
    resource.first_team = Team.new if resource.second_team.nil?
    resource.second_team = Team.new if resource.second_team.nil?
    super
  end

  private

  def match_params
    params.require(:match).permit(
      :rule,
      :games_rule,
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
      ],
      games_attributes: [
        :id,
        :_destroy,
        :first_team_points,
        :second_team_points
      ]
    )
  end
end
