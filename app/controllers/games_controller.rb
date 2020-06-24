class GamesController < InheritedResources::Base
  actions :all, except: :show

  def new
    resource ||= build_resource
    resource.teams.exists? || 2.times do
      resource.teams.build
    end
    super
  end

  private

  def game_params
    params.require(:game).permit(
      :rule,
      teams_attributes: [
        :id,
        :score,
        team_users_attributes: %i[id user_id _destroy]
      ]
    )
  end
end
