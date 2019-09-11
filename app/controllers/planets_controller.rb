class PlanetsController < ApplicationController
    def index 
        planets = Planet.all.select do |p|
            p.isConstellation == false
        end
        render json: planets
    end

    def moons
        moons = Planet.find(params[:id]).moons
        render json: moons
    end

    def constellations
        constellations = Planet.all.select do |p|
            p.isConstellation
        end
        render json: constellations
    end
end
