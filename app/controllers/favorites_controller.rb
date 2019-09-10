class FavoritesController < ApplicationController
    def index
        byebug
        favorites = Favorite.all 
        render json: favorites
    end
end
