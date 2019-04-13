class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :bulk_discounts, :type, :discount_type
  end
end
