# rule                :integer
# first_team          :references   not null
# second_team         :references   not null
# winner              :references
# first_team_points   :integer      not null  default: 0
# second_team_points  :integer      not null  default: 0
# match               :references
# round               :integer
class Game < ApplicationRecord
  belongs_to :first_team, class_name: 'Team'
  belongs_to :second_team, class_name: 'Team'
  belongs_to :match, optional: true
end
