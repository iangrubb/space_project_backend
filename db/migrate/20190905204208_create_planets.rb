class CreatePlanets < ActiveRecord::Migration[6.0]
  def change
    create_table :planets do |t|
      t.string :name
      t.string :latin_name
      t.boolean :isPlanet
      t.integer :gravity
      t.integer :density

      t.timestamps
    end
  end
end
