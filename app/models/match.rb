# first_team          :references   not null
# second_team         :references   not null
# winner              :references
# first_team_points   :references   not null  default: 0
# second_team_points  :references   not null  default: 0
# rule                :integer      not null
# games_rule          :integer      not null
class Match < ApplicationRecord
  belongs_to :first_team
  belongs_to :second_team
  belongs_to :winner
end
