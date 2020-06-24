class Team < ApplicationRecord
  enum status: %i[looser winner in_progress]
  belongs_to :teamable, polymorphic: true

  has_many :team_users, dependent: :destroy
  has_many :users, through: :team_users

  accepts_nested_attributes_for :team_users

  validate :users_empty?

  after_commit :set_status, if: -> { previous_changes[:score] }

  def users_empty?
    errors.add(:score, :users_empty) if team_users.empty?
  end

  def set_status
    self.status = if score > other_team.score &&
                     score >= teamable.rule.to_i
                    :winner
                  elsif score < other_team.score &&
                        other_team.score >= teamable.rule.to_i
                    :looser
                  else
                    :in_progress
                  end
    save
  end

  def other_team
    teamable.teams.where.not(id: id).first
  end
end
