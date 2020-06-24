class Game < ApplicationRecord
  enum rule: %i[11 21]

  belongs_to :match, optional: true

  has_many :teams, dependent: :destroy
  has_many :team_users, through: :teams
  has_many :users, through: :team_users
  accepts_nested_attributes_for :teams

  validate :two_teams?

  def two_teams?
    errors.add(:teams, :two_teams) if teams.length != 2
  end
end
