class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs do |t|
      t.string :name, null: false
      t.timestamps
      t.references :advertisement, null: false, foreign_key: { to_table: :advertisements, primary_key: :ad_id }
    end
  end
end