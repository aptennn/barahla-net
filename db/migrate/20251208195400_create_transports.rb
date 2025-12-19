class CreateTransports < ActiveRecord::Migration[8.0]
  def change
    create_table :transports do |t|
      t.string :brand, null: false
      t.string :model, null: false
      t.string :year, null: false
      t.integer :mileage, null: false
      t.string :fuel_type, null: false
      t.string :transmission, null: false
      t.integer :engine_capacity, null: false
      t.timestamps
      t.references :advertisement, null: false, foreign_key: { to_table: :advertisements, primary_key: :ad_id }
    end
  end
end