class GamesController < InheritedResources::Base
  actions :all, except: :show

  def new
    resource ||= build_resource
    resource.t_one ||= Team.new
    resource.t_two ||= Team.new
    super
  end

  private

  def game_params
    params.require(:game).permit(
      :rule,
      :winner,
      :t_one_score,
      :t_two_score,
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
      ]
    )
  end
end
