class CreateDriveTimeDestinations < ActiveRecord::Migration[6.1]
  def change
    create_table :drive_time_destinations do |t|
      t.integer :destination_id
      t.string :route_destination
      t.integer :min_route_time
      t.integer :travel_time
      t.integer :delay
      t.references :drive_time_origin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
