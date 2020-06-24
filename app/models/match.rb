class Match < ApplicationRecord
  has_many :games
  has_many :teams, through: :games
  has_many :users, through: :games
end
