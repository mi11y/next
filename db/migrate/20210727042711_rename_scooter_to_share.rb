class RenameScooterToShare < ActiveRecord::Migration[6.1]
  def self.up
    rename_table :scooters, :share
  end

  def self.down
    rename_table :share, :scooters
  end
end
