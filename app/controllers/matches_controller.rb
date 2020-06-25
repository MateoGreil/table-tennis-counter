class MatchesController < InheritedResources::Base

  def new
    resource ||= build_resource
    resource.t_one ||= Team.new
    resource.t_two ||= Team.new
    super
  end

  def edit
    resource.games_rule ||= resource.games.first&.rule
    super
  end

  private

  def match_params
    params.require(:match).permit(
      :rule,
      :winner,
      :t_one_score,
      :t_two_score,
      :games_rule,
      t_one_attributes: [
        :id,
        team_users_attributes: [
          :_destroy,
          :id,
          :user_id
        ]
      ],
      t_two_attributes: [
        :id,
        team_users_attributes: [
          :_destroy,
          :id,
          :user_id
        ]
      ],
      games_attributes: [
        :_destroy,
        :id,
        :t_one_score,
        :t_two_score
      ]
    )
  end
end
