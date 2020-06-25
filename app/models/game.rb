# == Table: games
# match :references
#
class Game < ApplicationRecord
  enum rule: %i[11 21]

  belongs_to :match, optional: true, touch: true

  belongs_to :t_one, class_name: 'Team'
  belongs_to :t_two, class_name: 'Team'
  has_many :team_users, through: %i[t_one t_two]
  has_many :users, through: :team_users

  accepts_nested_attributes_for :t_one, :t_two

  validates :rule, presence: true

  before_save :set_winner

  def t_one_status
    return :winner if winner == false

    return :looser if winner == true
  end

  def t_two_status
    return :winner if winner == true

    return :looser if winner == false
  end

  private

  def set_winner
    self.winner = if t_one_score >= rule.to_i &&
                     t_one_score - 2 >= t_two_score
                    false
                  elsif t_two_score >= rule.to_i &&
                        t_two_score - 2 >= t_one_score
                    true
                  end
  end
end
