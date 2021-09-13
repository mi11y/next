class CreateScooters < ActiveRecord::Migration[6.1]
  def change
    create_table :scooters do |t|
      t.references :scooter_brand, null: false, foreign_key: true
      t.string :lat
      t.string :lon
      t.string :bike_uuid
      t.integer :disabled
      t.integer :reserved

      t.timestamps
    end
  end
end
