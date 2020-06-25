# frozen_string_literal: true

# == Table: matches
#
# winner                  :boolean
# t_one                   references: :teams
# t_two                   references: :teams
# t_one_score             :integer
# t_two_score             :integer
# rule                    :integer            not null
class Match < ApplicationRecord
  enum rule: %i[3 5]
  enum status: %i[looser winner in_progress]

  has_many :games
  belongs_to :t_one, class_name: 'Team'
  belongs_to :t_two, class_name: 'Team'
  has_many :team_users, through: %i[t_one t_two]
  has_many :users, through: :team_users

  accepts_nested_attributes_for :t_one, :t_two, :games

  before_save :set_winner
  before_validation :set_games_attributes
  before_save :set_score
  
  attr_accessor :games_rule

  def set_winner
    self.winner = if games.length < rule.to_i
                    nil
                  elsif games.where(winner: false).length >
                        games.where(winner: true).length
                    false
                  else
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
