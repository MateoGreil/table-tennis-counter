class MatchesController < InheritedResources::Base

  def new
    resource ||= build_resource
    resource.team_teamables.build while resource.team_teamables.length < 2
    resource.team_teamables.each do |team_teamable|
      team_teamable.team = Team.new
    end
    super
  end

  private

  def match_params
    params.require(:match).permit(
      :rule,
      :winner,
      team_teamables_attributes: [
        :id,
        :score,
        team_attributes: [
          :id,
          team_users_attributes: [
            :_destroy,
            :id,
            :user_id
          ]
        ]
      ],
      games_attributes: [
        :_destroy,
        :id,
        team_teamables_attributes: [
          :id,
          :score
        ]
      ]
    )
  end
end
