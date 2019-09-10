class User < ApplicationRecord
    has_many :favorites
    has_many :planets, through: :favorites

    validates :username, presence: true, uniqueness: true
    has_secure_password
end
