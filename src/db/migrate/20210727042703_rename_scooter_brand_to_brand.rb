class RenameScooterBrandToBrand < ActiveRecord::Migration[6.1]
  def self.up
    rename_table :scooter_brands, :brand
  end

  def self.down
    rename_table :brand, :scooter_brands
  end
end
