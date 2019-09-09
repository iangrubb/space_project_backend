class User < ApplicationRecord
    has_many :favorites
    has_many :planets, through: :favorite

    validates :username, presence: true, uniqueness: true
    has_secure_password
end
