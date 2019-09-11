class UsersController < ApplicationController


    def create
        user = User.new(username: params[:username], password: params[:password])
        if user.valid?
          user.save
          render json: {user: user.id, username: user.username, token: JWT.encode({userId: user.id}, 'secret'), planets: user.planets}
        else
          render json: {errors: user.errors.full_messages}
        end

    end

    def destroyFav
      user = User.find(params[:id])
      favorite = Favorite.find_by(planet_id: params[:planet_id], user_id: params[:id])
      favorite.destroy
    end

    def favorites
      favorite = Favorite.create(user_id: params[:user], planet_id: params[:planet])
      render json: favorite
    end
end
