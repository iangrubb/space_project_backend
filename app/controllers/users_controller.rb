class UsersController < ApplicationController


    def create

        user = User.new(username: params[:username], password: params[:password])

        if user.save
          render json: {user: user.id, token: JWT.encode({userId: user.id}, 'secret'), planets: user.planets}
        else
          render json: {errors: user.errors.full_messages}
        end

    end

    def favorites
      user = User.find(params[:id])
      render json: user.planets
  end

end
