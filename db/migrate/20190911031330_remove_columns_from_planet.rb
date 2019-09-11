class RemoveColumnsFromPlanet < ActiveRecord::Migration[6.0]
  def change
    remove_column :planets, :density
    remove_column :planets, :gravity
    add_column :planets, :isConstellation, :boolean
  end
end
