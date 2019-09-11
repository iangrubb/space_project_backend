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
constellationArr = []
constellation = [
    "Canis Major",
    "Andromeda",
    "Apus",
    "Aquarius",
    "Ara",
    "Camelopardalis",
    "Cancer",
    "Capricornus",
    "Carina",
    "Cassiopeia",
    "Cepheus",
    "Cetus",
    "Chamaeleon",
    "Corona Borealis",
    "Corvus",
    "Crater",
    "Cygnus",
    "Dorado",
    "Gemini",
    "Hercules",
    "Lacerta",
    "Lepus",
    "Libra",
    "Lupus",
    "Lyra",
    "Orion",
    "Phoenix",
    "Scorpius",
    "Taurus",
    "Ursa Major",
    "Virgo"
  ]

constellation.each do |constellation|
    hash = {
        name: constellation,
        aka: constellation,
        isPlanet:false,
        isConstellation: true,
        distanceFromSun: 0,
        withInSolarSystem: true
    }
    constellationArr.push(hash)
end

constellationArr.each do |constellation|
    if constellation[:name].split().length == 2
        newName = constellation[:name]
    elsif ["Apus","Camelopardalis",'Capricornus','Cetus','Chamaeleon','Dorado','Lacerta','Lyra','Scorpius'].include?(constellation[:name])
        newName = constellation[:name]
    else
        newName = constellation[:name]+'_(constellation)'
    end
    url = wiki(newName)
    wikiResp = JSON.parse( RestClient.get(url))
    filteredWikiResp = wikiResp["query"]["pages"].values
    constellation[:info] = filteredWikiResp[0]["extract"]
end

# binding.pry
# puts "hello"


# customize API response to have around planets as nill
soloPlanets = resp['bodies'].select do |planet|
    planet["aroundPlanet"] == nil 
end.each do |planet|
    hash = {
        name: planet["id"],
        aka: planet["englishName"],
        isPlanet: planet["isPlanet"],
        isConstellation: false,
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


solarSystem = arr.each do |planet|
    if planet[:isPlanet] == true || planet[:aka] == "Sun"
        planet[:isPlanet] = true
        planet[:withInSolarSystem] = true
    else
        planet[:withInSolarSystem] = false
    end
end

nonPlanets = arr.select do |planet|
    planet[:isPlanet] == false
end


planets = solarSystem.select do |planet|
   planet[:isPlanet]
end.sort_by do |planet|
    planet[:distanceFromSun]
end

planets.each do |planet|
    if planet[:aka] == "Mercury"
        newName = 'Mercury_(planet)'
    elsif ["136472 Makemake", "136108 Haumea"].include?(planet[:aka])
        newName = planet[:name]
    elsif planet[:aka] == "136199 Eris"
        newName = "Eris_(dwarf_planet)"
    elsif planet[:aka] == "1 Ceres"
        newName = 'Ceres_(dwarf_planet)'
    else
        newName = planet[:aka]
    end
    url = wiki(newName)
    wikiResp = JSON.parse( RestClient.get(url))
    filteredWikiResp = wikiResp["query"]["pages"].values
    planet[:info] = filteredWikiResp[0]["extract"]
end


nonPlanets.each do |planet|
    if planet[:name] == "steins"
        newName = "2867_%C5%A0teins"
    elsif planet[:aka].include?("comet")
        newName = planet[:aka]
    elsif planet[:aka] == "Shoemaker-Levy 9"
        newName = "Comet_Shoemaker%E2%80%93Levy_9"
    elsif planet[:aka] == "Ultima Thule"
        newName = "(486958)_2014_MU69"
    elsif planet[:aka] == "3 Junon"
        newName = "3_Juno"
    else
        newName= planet[:aka].split().join("_")
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
        isConstellation: planet[:isConstellation],
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

constellationArr.each do |constellation|
    Planet.create(
        name:constellation[:aka],
        latin_name: constellation[:name],
        isPlanet: constellation[:isPlanet],
        isConstellation: constellation[:isConstellation],
        info: constellation[:info],
        distanceFromSun: constellation[:distanceFromSun],
        withInSolarSystem: constellation[:withInSolarSystem],
    )
end

nonPlanets.each do |planet|
    createdPlanet = Planet.create(
        name:planet[:aka],
        latin_name: planet[:name],
        isPlanet: planet[:isPlanet],
        isConstellation: planet[:isConstellation],
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


