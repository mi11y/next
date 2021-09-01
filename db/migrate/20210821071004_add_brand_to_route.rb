class AddBrandToRoute < ActiveRecord::Migration[6.1]
  def change
    add_reference :routes, :brand, null: false, foreign_key: true
  end
end
