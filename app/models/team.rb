# created_at  :datetime
# updated_at  :datetime
class Team < ApplicationRecord
  has_many :team_users
  has_many :users, through: :team_users

  accepts_nested_attributes_for :team_users
end
