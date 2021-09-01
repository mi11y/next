class RenameScooterBrandColumnToBrandColumn < ActiveRecord::Migration[6.1]
  def self.up
    rename_column :share, :scooter_brand_id, :brand_id
  end

  def self.down
    rename_column :share, :brand_id, :scooter_brand_id
  end
end
