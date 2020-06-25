# == Table: games
# match   :references
# winner  references: :teams
# rule    :integer            not null
class Game < ApplicationRecord
  enum rule: %i[11 21]

  belongs_to :match, optional: true, touch: true

  has_many :team_teamables, as: :teamable, dependent: :destroy
  has_many :teams, through: :team_teamables
  has_many :users, through: :teams

  accepts_nested_attributes_for :team_teamables

  validates :rule, presence: true
  validates :team_teamables, presence: true

  after_save :set_winner

  private

  def set_winner
    looser = team_teamables.order(:score).first
    winner = team_teamables.order(:score).last
    return unless winner.score >= rule.to_i && looser.score + 2 <= winner.score

    winner.update(status: :winner)
    looser.update(status: :looser)
  end

end
