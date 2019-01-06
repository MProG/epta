class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.float :current_price
      t.float :base_price
      t.string :location
      t.string :type

      t.timestamps
    end
  end
end
