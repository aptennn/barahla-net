class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.integer :id, primary_key: true
      t.integer :city_id
      t.string :email
      t.string :password_digest
      t.string :username
      t.string :phone
      t.float :rating

      t.timestamps

      t.index :email, unique: true
      t.index :username, unique: true
      t.index :city_id
    end
  end
end
