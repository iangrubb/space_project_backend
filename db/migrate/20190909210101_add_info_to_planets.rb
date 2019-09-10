class AddInfoToPlanets < ActiveRecord::Migration[6.0]
  def change
    add_column :planets, :info, :string
  end
end
