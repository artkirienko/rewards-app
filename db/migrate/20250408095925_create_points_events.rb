class CreatePointsEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :points_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :source, polymorphic: true, null: false
      t.integer :points

      t.timestamps
    end
  end
end
