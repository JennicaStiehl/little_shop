class RemoveColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :bulk_discounts, :discount
    remove_column :bulk_discounts, :discount_type
    add_column :bulk_discounts, :discount, :integer
  end
end
