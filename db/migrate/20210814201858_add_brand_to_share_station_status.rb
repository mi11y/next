class AddBrandToShareStationStatus < ActiveRecord::Migration[6.1]
  def change
    add_reference :share_station_statuses, :brand, null: false, foreign_key: true
  end
end
