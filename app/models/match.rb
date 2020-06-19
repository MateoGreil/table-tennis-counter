class Match < ApplicationRecord
  has_one :game
  has_many :teams, through: :game
  has_many :users, through: :game
end
