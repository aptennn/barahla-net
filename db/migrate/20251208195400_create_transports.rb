class CreateTransports < ActiveRecord::Migration[8.0]
  def change
    create_table :transports, id: false do |t|
      t.integer :category_id, primary_key: true
      t.string :brand, null: false
      t.string :model, null: false
      t.string :year, null: false
      t.integer :mileage, null: false
      t.string :fuel_type, null: false
      t.string :transmission, null: false
      t.integer :engine_capacity, null: false
      t.timestamps
    end
  end
end
