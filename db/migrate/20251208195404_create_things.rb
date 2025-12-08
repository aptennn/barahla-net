class CreateThings < ActiveRecord::Migration[8.0]
  def change
    create_table :things, id: false do |t|
      t.integer :category_id, primary_key: true
      t.string :name, null: false
      t.string :type, null: false
      t.timestamps
    end
  end
end
