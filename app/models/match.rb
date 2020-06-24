class Match < ApplicationRecord
  enum rule: %i[11 21]

  has_many :games
  has_many :teams, dependent: :destroy, as: :teamable
  has_many :users, through: :games
end
