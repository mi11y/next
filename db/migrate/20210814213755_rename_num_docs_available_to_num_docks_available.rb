class RenameNumDocsAvailableToNumDocksAvailable < ActiveRecord::Migration[6.1]
  def change
    rename_column :share_station_statuses, :num_docs_available, :num_docks_available
  end
end
