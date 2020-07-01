# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    can %i[show index], User
    can %i[index create], Game
    can %i[index show create], Match

    can %i[edit update destroy], [Game, Match] do |object|
      object.winner.nil?
    end

    return unless user.admin?

    can :manage, :all
  end
end
