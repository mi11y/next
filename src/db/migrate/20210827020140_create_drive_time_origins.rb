class CreateDriveTimeOrigins < ActiveRecord::Migration[6.1]
  def change
    create_table :drive_time_origins do |t|
      t.integer :origin_id
      t.string :location_name
      t.string :lat
      t.string :lon

      t.timestamps
    end
  end
end
