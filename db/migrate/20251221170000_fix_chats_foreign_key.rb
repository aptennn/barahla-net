class FixChatsForeignKey < ActiveRecord::Migration[8.0]
  def change
    # Drop the existing chats table
    drop_table :chats

    # Recreate it with correct foreign key reference
    create_table :chats do |t|
      t.references :advertisement, null: false, foreign_key: { to_table: :advertisements, primary_key: :ad_id }
      t.references :ad_owner, null: false, foreign_key: { to_table: :users }
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.datetime :created_time, null: false

      t.timestamps
    end
  end
end