class FavoritesController < ApplicationController
    def index
        favorites = Favorite.all 
        render json: favorites
    end

    def  destroy
        favorite = Favorite.find_by(planet_id: params[:id],user_id: params[:user_id] )
        byebug
        render json: favorite
    end
end
