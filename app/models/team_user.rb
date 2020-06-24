# frozen_string_literal: true

# == Table: team_users
#
# user                    :references not null
# team                    :references not null
# created_at              :datetime
# updated_at              :datetime
class TeamUser < ApplicationRecord
  belongs_to :user
  belongs_to :team
end
