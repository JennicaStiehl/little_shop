class ChangeColumnType < ActiveRecord::Migration[5.1]
  def change
    remove_column :bulk_discounts, :type
    add_column :bulk_discounts, :type, :integer
  end
end
