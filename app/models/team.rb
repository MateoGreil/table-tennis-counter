# frozen_string_literal: true

# == Table: teams
#
# created_at              :datetime
# updated_at              :datetime
class Team < ApplicationRecord
  has_many :team_users, dependent: :destroy
  has_many :users, through: :team_users

  accepts_nested_attributes_for :team_users

  validate :users_empty?

  def users_empty?
    errors.add(:score, :users_empty) if team_users.empty?
  end

end
