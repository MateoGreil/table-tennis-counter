class GamesController < InheritedResources::Base
  actions :all, except: :show

  private

  def game_params
    params.require(:game).permit(
      :rule,
      :winner,
      :t_one_id,
      :t_two_id,
      :t_one_score,
      :t_two_score
    )
  end
end
