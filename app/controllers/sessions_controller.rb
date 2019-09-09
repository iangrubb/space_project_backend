class SessionsController < ApplicationController


    def login
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
          render json: {user: user, token: JWT.encode({userId: user.id}, 'secret')} 
        else 
          render json: {errors: 'please enter the correct username and password'}
        end
    
    end

    def autologin

        token = request.headers['Authorization']
        user_id = JWT.decode(token, 'secret')[0]["userId"]
        user = User.find(user_id)
        render json: user

    end

end