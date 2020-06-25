# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    # Games
    can %i[new create show index], Game
    can %i[edit update destroy], Game do |game|
      !game.team_teamables.pluck(:status).include?('winner')
    end
  end
end
