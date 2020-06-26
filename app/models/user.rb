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
# confirmation_token      :string
# confirmed_at            :datetime
# confirmation_sent_at    :datetime
# unconfirmed_email       :string
# failed_attempts         :integer    not null  default: 0
# unlock_token            :string
# locked_at               :datetime
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
  has_many :games, through: :teams
  has_many :matches, through: :teams
end
