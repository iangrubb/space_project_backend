class MoonsController < ApplicationController
    def index 
        moons = Moon.all
        render json: moons
    end
end
