require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe 'merchant order show workflow' do
  describe 'as a merchant' do
    before :each do
      @merchant1 = create(:merchant, slug:nil)
      @merchant2 = create(:merchant, slug:nil)
      @user = create(:user, slug: nil)
      @order = create(:order, user: @user)
      @item1 = create(:item, name: 'widget', slug: nil,  user: @merchant1, inventory: 2)
      @item2 = create(:item, name: 'widget', slug: nil,  user: @merchant2, inventory: 2)
      @item3 = create(:item, name: 'widget', slug: nil,  user: @merchant1, inventory: 2)
      @item4 = create(:item, name: 'widget', slug: nil,  user: @merchant1, inventory: 2)
      @oi1 = create(:order_item, order: @order, item: @item1, quantity: 1, price: 2)
      @oi2 = create(:order_item, order: @order, item: @item2, quantity: 2, price: 3)
      @oi3 = create(:order_item, order: @order, item: @item3, quantity: 3, price: 4)
      @oi4 = create(:order_item, order: @order, item: @item4, quantity: 3, price: 4)
      @merchant_1 = create(:merchant, slug:nil)
      @merchant_2 = create(:merchant, slug:nil)
      @item_1 = create(:item, name: 'widget', slug: nil,  user: @merchant_1, inventory: 3)
      @item_2 = create(:item, name: 'widget', slug: nil,  user: @merchant_2)
      @item_3 = create(:item, name: 'widget', slug: nil,  user: @merchant_2)
      @discount5 =@item_3.bulk_discounts.create(threshold:12, discount: 3)
      @discount10 = @item_3.bulk_discounts.create(threshold:24, discount: 6)
      @discount15 = @item_2.bulk_discounts.create(threshold:36, discount: 9)
      @discount15 = @item_1.bulk_discounts.create(threshold:36, discount: 9)
      # @oi_1 = create(:order_item, order: @order, item: @item_1, quantity: 1, price: 2)
      # @oi_2 = create(:order_item, order: @order, item: @item_2, quantity: 2, price: 3)
      # @oi_3 = create(:order_item, order: @order, item: @item_3, quantity: 3, price: 4)
      # @oi_4 = create(:order_item, order: @order, item: @item_4, quantity: 3, price: 4)
    end

    it 'reduces the price if a discount was applied in the cart' do
      visit item_path(@item_1)
      click_on "Add to Cart"
      visit item_path(@item_2)
      click_on "Add to Cart"
      visit item_path(@item_3)
      click_on "Add to Cart"
      visit item_path(@item_3)
      click_on "Add to Cart"
      @user.reload
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_orders_path
      click_link("#{@order.id}")
      click_on "Cart"
      click_on "Check Out"
      @new_order = Order.last
      @new_order.reload

      # visit dashboard_order_path(@new_order.id)
      visit "/profile/orders/#{@new_order.id}"

      within "#oitem-#{@new_order.order_items.first.id}" do
        actual = number_to_currency(@new_order.order_items.first.price)
        expect(page).to have_content("Subtotal: $9.00")
        # expect(actual).to eq("Price: $3.00")
      end
    end
  end
end
