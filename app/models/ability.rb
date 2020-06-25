# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    # Games
    can %i[new create show index], Game
    can %i[update destroy], Game
  end
end
