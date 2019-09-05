# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'rest-client'

#Solar System API 
api  = "https://api.le-systeme-solaire.net/rest/bodies/"

resp = JSON.parse( RestClient.get(api) )

resp.each do |key,value| 
    value.each do |k| 
        Planet.create({name: k["englishName"], latin_name: k["name"], isPlanet: k["isPlanet"]})
    end
end
