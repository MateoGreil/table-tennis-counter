# teamable  :references polymorphic
# team      :references
# score     :integer
class TeamTeamable < ApplicationRecord
  belongs_to :teamable
  belongs_to :team
end
