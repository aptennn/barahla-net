class CreateCities < ActiveRecord::Migration[8.0]
  def change
    create_table :cities, id: false do |t|
      t.integer :city_id, primary_key: true
      t.string :name, null: false
      t.string :region, null: false
      t.string :country, null: false
      t.timestamps
    end
  end
end
