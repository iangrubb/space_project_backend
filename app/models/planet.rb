class Planet < ApplicationRecord
    has_many :favorites
    has_many :users, through: :favorite

end
