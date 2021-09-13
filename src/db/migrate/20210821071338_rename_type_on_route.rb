class RenameTypeOnRoute < ActiveRecord::Migration[6.1]
  def change
    rename_column :routes, :type, :route_type
  end
end
