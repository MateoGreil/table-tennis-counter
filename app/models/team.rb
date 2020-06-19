class Team < ApplicationRecord
  belongs_to :game

  has_many :team_users
  has_many :users, through: :team_users
end
