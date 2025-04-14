class CreateBonuses < ActiveRecord::Migration[8.0]
  def change
    create_table :bonuses do |t|
      t.string :name
      t.text :description
      t.integer :points, default: 0

      t.timestamps
    end
  end
end
