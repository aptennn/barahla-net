class CreateRealEstates < ActiveRecord::Migration[8.0]
  def change
    create_table :real_estates do |t|
      t.string :type, null: false
      t.float :total_area, null: false
      t.float :living_area, null: false
      t.integer :floor, null: false
      t.integer :total_floors, null: false
      t.integer :rooms_count, null: false
      t.timestamps
      t.references :advertisement, null: false, foreign_key: { to_table: :advertisements, primary_key: :ad_id }
    end
  end
end