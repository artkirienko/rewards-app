class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email_address
      t.integer :points, default: 0

      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
