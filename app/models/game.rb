class Game < ApplicationRecord
  belongs_to :first_team, class_name: 'Team'
  belongs_to :second_team, class_name: 'Team'
  belongs_to :match, optional: true
end
