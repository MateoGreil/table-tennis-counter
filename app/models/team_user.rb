# user        :references
# team        :references
# created_at  :datetime
# updated_at  :datetime
class TeamUser < ApplicationRecord
  belongs_to :user
  belongs_to :team
end
