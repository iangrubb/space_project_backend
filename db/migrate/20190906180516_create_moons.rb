class CreateMoons < ActiveRecord::Migration[6.0]
  def change
    create_table :moons do |t|
      t.belongs_to :planet, null: false, foreign_key: true
      t.string :name
      t.boolean :isPlanet
      t.integer :density
      t.integer :gravity

      t.timestamps
    end
  end
end
