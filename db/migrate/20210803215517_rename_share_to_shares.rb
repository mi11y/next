class RenameShareToShares < ActiveRecord::Migration[6.1]
  def self.up
    rename_table :share, :shares
  end

  def self.down
    rename_table :shares, :share
  end
end
