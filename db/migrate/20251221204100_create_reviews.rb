class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.integer :review_id
      t.integer :user_id
      t.integer :user_to_id
      t.integer :rating
      t.text :text

      t.timestamps
    end
  end
end