class CreateRealEstates < ActiveRecord::Migration[8.0]
  def change
    create_table :real_estates, id: false do |t|
      t.integer :category_id, primary_key: true
      t.string :type, null: false
      t.float :total_area, null: false
      t.float :living_area, null: false
      t.integer :floor, null: false
      t.integer :total_floors, null: false
      t.integer :rooms_count, null: false
      t.timestamps
    end
  end
end
