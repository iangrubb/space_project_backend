# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# require 'pry'
require 'rest-client'

#Solar System API 
api  = "https://api.le-systeme-solaire.net/rest/bodies/"

def wiki(planet)
    'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&titles=' + planet + '&exintro=1&explaintext=1'
end

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
        moon: [],
        distanceFromSun: planet["perihelion"],
        withInSolarSystem: false
    }
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


nonPlanets = arr.select do |planet|
    planet[:isPlanet] == false
end

solarSystem = arr.each do |planet|
    if planet[:isPlanet] == true || planet[:aka] == "Sun"
        planet[:isPlanet] = true
    end
    planet[:withInSolarSystem] = true
end

planets = solarSystem.select do |planet|
   planet[:isPlanet]
end.sort_by do |planet|
    planet[:distanceFromSun]
end

planets.each do |planet|
    if planet[:name] == "steins"
        newName = planet[:name]
    elsif planet[:aka].include?("comet")
        newName = planet[:aka]
    elsif planet[:name] == "s19"
        newName = planet[:aka]
    else
        newName= planet[:aka].split()[-1]
    end
    url = wiki(newName)
    wikiResp = JSON.parse( RestClient.get(url))
    filteredWikiResp = wikiResp["query"]["pages"].values
    planet[:info] = filteredWikiResp[0]["extract"]
end


planets.each do |planet|
    createdPlanet = Planet.create(
        name:planet[:aka],
        latin_name: planet[:name],
        isPlanet: planet[:isPlanet],
        density: planet[:density],
        gravity: planet[:gravity],
        info: planet[:info],
        distanceFromSun: planet[:distanceFromSun],
        withInSolarSystem: planet[:withInSolarSystem]
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


