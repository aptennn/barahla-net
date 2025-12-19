class CreateAdvertisements < ActiveRecord::Migration[8.0]
  def change
    create_table :advertisements, id: false do |t|
      t.integer :ad_id, primary_key: true
      t.references :user, null: false, foreign_key: { to_table: :users, primary_key: :id }
      t.references :city, null: false, foreign_key: { to_table: :cities, primary_key: :city_id }
      t.integer :category_id, null: false
      t.string :status, null: false, default: 'active'
      t.float :price, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.timestamps
    end
  end
end