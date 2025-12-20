class CreateAdvertisementPictures < ActiveRecord::Migration[8.0]
  def change
    create_table :advertisement_pictures do |t|
      t.integer :ad_id, null: false
      t.integer :position
      t.timestamps

      t.index :ad_id
      t.foreign_key :advertisements, column: :ad_id, primary_key: :ad_id
    end
  end
end
