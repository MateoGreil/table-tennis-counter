# frozen_string_literal: true

# == Table: users
#
# email                   :string     not null  default: ""
# login                   :string     not null                uniq
# encrypted_password      :string     not null  default: ""
# reset_password_token    :string
# reset_password_sent_at  :datetime
# remember_created_at     :datetime
# sign_in_count           :integer    not null  default: 0
# current_sign_in_at      :datetime
# last_sign_in_at         :datetime
# current_sign_in_ip      :inet
# last_sign_in_ip         :inet
## confirmation_token      :string
## confirmed_at            :datetime
## confirmation_sent_at    :datetime
## unconfirmed_email       :string
## failed_attempts         :integer    not null  default: 0
## unlock_token            :string
## locked_at               :datetime
# role                    :integer
# created_at              :datetime   not null
# updated_at              :datetime   not null

class User < ApplicationRecord
  extend FriendlyId
  friendly_id :login, use: :slugged
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :team_users
  has_many :teams, through: :team_users

  def games
    Game.select('DISTINCT games.*').joins('
      INNER JOIN teams AS first_teams
        ON first_teams.id = games.first_team_id
      INNER JOIN team_users AS first_team_team_users
        ON first_team_team_users.team_id = first_teams.id
    ').joins('
      INNER JOIN teams AS second_teams
        ON second_teams.id = games.second_team_id
      INNER JOIN team_users AS second_team_team_users
        ON second_team_team_users.team_id = second_teams.id
    ').where(
      'first_team_team_users.user_id = :user_id
      OR second_team_team_users.user_id = :user_id', { user_id: id }
    )
  end

  def matches
    Match.select('DISTINCT matches.*').joins('
      INNER JOIN teams AS first_teams
        ON first_teams.id = matches.first_team_id
      INNER JOIN team_users AS first_team_team_users
        ON first_team_team_users.team_id = first_teams.id
    ').joins('
      INNER JOIN teams AS second_teams
        ON second_teams.id = matches.second_team_id
      INNER JOIN team_users AS second_team_team_users
        ON second_team_team_users.team_id = second_teams.id
    ').where(
      'first_team_team_users.user_id = :user_id
      OR second_team_team_users.user_id = :user_id', { user_id: id }
    )
  end

  def enemy
    ActiveRecord::Base.connection.execute(
      <<-SQL
      SELECT users.login, COUNT(users.id)
      FROM users
      INNER JOIN team_users ON team_users.user_id = users.id
      INNER JOIN teams ON team_users.team_id = teams.id
      INNER JOIN games ON games.first_team_id = teams.id OR games.second_team_id = teams.id
      WHERE users.id != #{id}
      AND games.id IN 
        (SELECT
          games.id
        FROM
          games
        INNER JOIN teams
          ON games.first_team_id = teams.id OR games.second_team_id = teams.id
        INNER JOIN team_users
          ON team_users.team_id = teams.id
          AND team_users.user_id = #{id})
      AND teams.id NOT IN
        (SELECT
          teams.id
        FROM
          teams
        INNER JOIN team_users
          ON team_users.user_id = #{id})
      GROUP BY users.id
      ORDER BY count DESC
      SQL
    )
  end

end

        # select distinct .id as games_ids,
        # enemy_teams.id as enemy_teams_ids,
        # team_users.team_id as teams_ids
        # from games
        # left join teams as first_teams
        # on first_teams.id = games.first_team_id
        # left join teams as second_teams
        # on second_teams.id = games.second_team_id
        # left join team_users
        # ON (team_users.team_id = first_teams.id
        # OR team_users.team_id = second_teams.id)
        # AND team_users.user_id = 1
        # LEFT JOIN teams AS enemy_teams
        # ON (games.first_team_id = enemy_teams.id
        # OR games.second_team_id = enemy_teams.id)
        # AND team_users.team_id != enemy_teams.id
