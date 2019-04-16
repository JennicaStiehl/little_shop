class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates :price, presence: true, numericality: {
    only_integer: false,
    greater_than_or_equal_to: 0
  }
  validates :quantity, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1
  }

  def subtotal
    quantity * price
  end

  # def find_discount(order_item)
  #   if order_item
  #     subtotal = order_item.price * order_item.quantity
  #     item = Item.find_by(id: item_id)
  #     discount = item.discounts_by_item.find do |discount|
  #       discount.threshold == subtotal
  #       new_subtotal = subtotal - discount.discount
  #     end
  #   end
  # end


  

  def fulfill
    if item.inventory >= quantity && !self.fulfilled
      item.inventory -= quantity
      self.fulfilled = true
      item.save
      save
    end
  end

  def inventory_available
    item.inventory >= quantity
  end
end
