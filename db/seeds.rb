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

arr = []

# customize API response to have around planets as nill
soloPlanets = resp['bodies'].select do |planet|
    planet["aroundPlanet"] == nil 
end.each do |planet|
    hash = {
        name: planet["id"],
        aka: planet["englishName"],
        isPlanet: planet["isPlanet"],
        density: planet["density"],
        gravity: planet["gravity"],
        moon: []}
    arr.push(hash)
end

# add in around planets
pairPlanets = resp['bodies'].select do |planet|
    planet["aroundPlanet"] != nil 
end
pairPlanets.each do |planet|
    name = planet["aroundPlanet"]["planet"]  
    target = arr.find do |p| 
        p[:name] == name
    end
    if target != nil 
        target[:moon] << {
            name: planet["id"],
            aka: planet["englishName"],
            isPlanet: planet["isPlanet"],
            density: planet["density"],
            gravity: planet["gravity"],
        }
    end
end

arr.each do |planet|
    createdPlanet = Planet.create(
        name:planet[:aka],
        latin_name: planet[:name],
        isPlanet: planet[:isPlanet],
        density: planet[:density],
        gravity: planet[:gravity]
    )
    planet[:moon].each do |moon|
        Moon.create(
            planet_id: createdPlanet.id,
            name:moon[:aka],
            isPlanet: moon[:isPlanet],
            density: moon[:density],
            gravity: moon[:gravity]
        )
        
    end
end


