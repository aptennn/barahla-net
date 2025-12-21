class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.references :advertisement, null: false, foreign_key: { to_table: :advertisements, primary_key: :ad_id }
      t.references :ad_owner, null: false, foreign_key: { to_table: :users }
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.datetime :created_time, null: false

      t.timestamps
    end
  end
end