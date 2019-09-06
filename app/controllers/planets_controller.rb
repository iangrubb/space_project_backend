class PlanetsController < ApplicationController
    def index 
        planets = Planet.all
        render json: planets
    end

    def moons
        moons = Planet.find(params[:id]).moons
        render json: moons
    end
end
