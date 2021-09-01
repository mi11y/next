class CreateShareStations < ActiveRecord::Migration[6.1]
  def change
    create_table :share_stations do |t|
      t.string :lat
      t.string :lon
      t.integer :capacity
      t.string :name
      t.string :station_uuid
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
