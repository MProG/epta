class AddDiffToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :diff_percent, :float
  end
end
