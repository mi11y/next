class CreateRoutes < ActiveRecord::Migration[6.1]
  def change
    create_table :routes do |t|
      t.string :route_color
      t.boolean :frequent_service
      t.integer :route_number
      t.integer :route_id
      t.string :type
      t.string :desc
      t.integer :route_sort_order

      t.timestamps
    end
  end
end
