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

  has_many :games, dependent: :destroy
  belongs_to :t_one, class_name: 'Team', dependent: :destroy
  belongs_to :t_two, class_name: 'Team', dependent: :destroy
  has_many :team_users, through: %i[t_one t_two]
  has_many :users, through: :team_users

  accepts_nested_attributes_for :t_one, :t_two
  accepts_nested_attributes_for :games, allow_destroy: true

  before_save :set_winner
  before_validation :set_games_attributes
  after_touch -> { set_winner; save }

  attr_accessor :games_rule

  # validate :too_much_games?

  # def too_much_games?
  #   errors.add(:games, :too_much_games) if games.length > rule.to_i && games.first(rule.to_i).
  # end

  def set_winner
    set_score
    self.winner = if t_one_score > t_two_score &&
                     t_one_score + t_two_score - rule.to_i < t_one_score
                    false
                  elsif t_two_score > t_one_score &&
                        t_two_score + t_one_score - rule.to_i < t_two_score
                    true
                  end
  end

  def set_score
    # raise
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
