class AddShareStationToShareStationStatus < ActiveRecord::Migration[6.1]
  def change
    add_reference :share_station_statuses, :share_station, null: false, foreign_key: true
  end
end
