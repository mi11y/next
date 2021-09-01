class RenameBrandToBrands < ActiveRecord::Migration[6.1]
  def self.up
    rename_table :brand, :brands
  end

  def self.down
    rename_table :brands, :brand
  end
end
