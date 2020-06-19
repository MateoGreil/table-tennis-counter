class Game < ApplicationRecord
  belongs_to :match

  has_many :teams
  has_many :users, through: :teams
end
