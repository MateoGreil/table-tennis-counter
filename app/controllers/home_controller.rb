class HomeController < ApplicationController
  
  def index
    @matchs = Match.joins(:users).where('users.id = ?', current_user.id)
    @games = Game.joins(:users).where('users.id = ?', current_user.id)
    @teams = Team.joins(:users).where('users.id = ?', current_user.id)
  end
end
