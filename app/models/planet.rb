class Planet < ApplicationRecord
    has_many :favorites
    has_many :users, through: :favorite
    has_many :moons

end
