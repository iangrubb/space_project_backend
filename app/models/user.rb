class User < ApplicationRecord
    has_many :favorites
    has_many :planets, through: :favorite
end
