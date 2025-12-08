class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs, id: false do |t|
      t.integer :category_id, primary_key: true
      t.string :name, null: false
      t.timestamps
    end
  end
end
