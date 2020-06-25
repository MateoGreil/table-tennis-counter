# frozen_string_literal: true

# == Table: matches
#
# winner                  references: :teams
# rule                    :integer            not null
class Match < ApplicationRecord
  enum rule: %i[3 5]
  enum games_rule: Game.rules.keys

  has_many :games, dependent: :destroy
  has_many :team_teamables, as: :teamable, dependent: :destroy
  has_many :teams, through: :team_teamables
  has_many :users, through: :teams

  accepts_nested_attributes_for :team_teamables
  accepts_nested_attributes_for :games

  after_save :set_winner
  before_validation :set_games_attributes
  after_touch -> { set_winner; save }

  attr_accessor :games_rule

  def set_winner
    set_score
    cap_win = rule.to_s == '3' ? 1 : 2
    self.winner = if t_one_score > t_two_score &&
                     t_one_score + t_two_score >= rule.to_i - cap_win
                    false
                  elsif t_two_score > t_one_score &&
                        t_two_score + t_one_score >= rule.to_i - cap_win
                    true
                  end
  end

  def set_score
    self.t_one_score = games.where(winner: false).length
    self.t_two_score = games.where(winner: true).length
  end

  def set_games_attributes
    games.each do |game|
      game.t_one = t_one
      game.t_two = t_two
      game.rule = games_rule
    end
  end

  def t_one_status
    if winner.nil?
      :in_progress
    elsif winner == false
      :winner
    else
      :looser
    end
  end

  def t_two_status
    if winner.nil?
      :in_progress
    elsif winner == true
      :winner
    else
      :looser
    end
  end
end
