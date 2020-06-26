class GamesController < InheritedResources::Base
  actions :all, except: :show
  load_and_authorize_resource

  def new
    resource ||= build_resource
    resource.first_team.build if resource.second_team.nil?
    resource.second_team.build if resource.second_team.nil?
    super
  end

  private

  def game_params
    params.require(:game).permit(
    )
  end
end
