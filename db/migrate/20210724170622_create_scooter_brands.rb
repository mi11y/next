class CreateScooterBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :scooter_brands do |t|
      t.string :name

      t.timestamps
    end
  end
end
