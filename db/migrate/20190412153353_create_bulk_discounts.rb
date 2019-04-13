class CreateBulkDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bulk_discounts do |t|
      t.integer :threshold
      t.string :type
      t.decimal :discount, precision: 5, scale: 2
      t.references :item, foreign_key: true
    end
  end
end
