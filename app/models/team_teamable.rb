# teamable  :references polymorphic
# team      :references
# score     :integer
class TeamTeamable < ApplicationRecord
  enum status: %i[in_progress looser winner]

  belongs_to :teamable, polymorphic: true
  belongs_to :team

  has_many :users, through: :team

  accepts_nested_attributes_for :team
end
