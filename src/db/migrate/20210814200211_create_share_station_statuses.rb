class CreateShareStationStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :share_station_statuses do |t|
      t.string :station_id
      t.integer :num_docs_available
      t.integer :is_returning
      t.integer :is_installed
      t.integer :num_bikes_available
      t.integer :is_renting

      t.timestamps
    end
  end
end
