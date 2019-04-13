class ChangeDataType < ActiveRecord::Migration[5.1]
  def change
    remove_column :bulk_discounts, :discount
    add_column :bulk_discounts, :discount, :numeric, precision: 5, scale: 2
  end
end
