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
  enum rule: %i[11 21]

  has_many :games
  has_many :teams, dependent: :destroy, as: :teamable
  has_many :users, through: :games
end
