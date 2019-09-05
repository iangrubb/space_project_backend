class PlanetsController < ApplicationController
    def index 
        planets = Planets.all
        render: planets
    end
end
