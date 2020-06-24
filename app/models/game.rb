# frozen_string_literal: true

# == Table: games
#
# match                   :references
# winner                  :boolean
# t_one                   references: :teams
# t_two                   references: :teams
# t_one_score             :integer
# t_two_score             :integer
# rule                    :integer            not null
class Game < ApplicationRecord
  enum rule: %i[11 21]

  belongs_to :match, optional: true
  belongs_to :t_one, class_name: 'Team'
  belongs_to :t_two, class_name: 'Team'

  has_many :team_users, through: %i[t_one t_two]
  has_many :users, through: :team_users

  validates :rule, presence: true

  def teams
    Team.where(id: [t_one_id, t_two_id])
  end
end
