# created_at  :datetime
# updated_at  :datetime
class Team < ApplicationRecord
  has_many :team_users, dependent: :destroy
  has_many :users, through: :team_users
  has_many :first_games, class_name: 'Game', foreign_key: :first_team_id
  has_many :second_games, class_name: 'Game', foreign_key: :second_team_id

  accepts_nested_attributes_for :team_users

  def games
    Game.where('first_team_id = :team_id OR second_team_id = :team_id', {
      team_id: self.id
    })
  end
end
