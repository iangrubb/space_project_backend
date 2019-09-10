class AddDistanceFromSunToPlanet < ActiveRecord::Migration[6.0]
  def change
    add_column :planets, :distanceFromSun, :integer
    add_column :planets, :withInSolarSystem, :boolean
  end
end
