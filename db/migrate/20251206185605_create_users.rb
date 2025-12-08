class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.integer :user_id, primary_key: true
      t.integer :city_id, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :username, null: false
      t.string :phone, null: false
      t.float :rating, default: 0.0

      t.timestamps

      t.index :email, unique: true
      t.index :username, unique: true
      t.index :city_id
    end
  end
end
