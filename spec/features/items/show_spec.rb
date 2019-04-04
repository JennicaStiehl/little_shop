require "rails_helper"

RSpec.describe "item show page" do
  before :each do
    @merchant = create(:merchant)
    @item = create(:item, user: @merchant)
    @order_item_1 = create(:fulfilled_order_item, item: @item, created_at: 4.days.ago, updated_at: 12.hours.ago)
    @order_item_2 = create(:fulfilled_order_item, item: @item, created_at: 2.days.ago, updated_at: 1.day.ago)
    @order_item_3 = create(:fulfilled_order_item, item: @item, created_at: 2.days.ago, updated_at: 1.day.ago)
    @order_item_4 = create(:order_item, item: @item, created_at: 2.days.ago, updated_at: 1.day.ago)
  end

  it "displays the items info" do
    visit item_path(@item)

    expect(page).to have_content(@item.name)
    expect(page).to have_content(@item.description)
    expect(page).to have_xpath("//img[@src='#{@item.image}']")
    expect(page).to have_content(@item.user.name)
    expect(page).to have_content(@item.inventory)
    expect(page).to have_content(@item.price)
  end

  it "shows rounded up average fulfillment time" do
    visit item_path(@item)

    expect(page).to have_content("Average Fulfillment Time: 2 days")
  end

  it "shows rounded down average fulfillment time" do
    create(:fulfilled_order_item, item: @item, created_at: 4.days.ago, updated_at: 1.day.ago)
    visit item_path(@item)

    expect(page).to have_content("Average Fulfillment Time: 2 days")
  end

  it "displays no average fulfillment time if there are no order items" do
    merchant = create(:merchant)
    item = create(:item, user: merchant)
    order_item_4 = create(:order_item, item: item, created_at: 2.days.ago, updated_at: 1.day.ago)
    visit item_path(item)

    expect(page).to_not have_content("Average Fulfillment Time:")
  end

  context "as a visitor" do
    it "has a link to add the item to the cart" do
      visit item_path(@item)

      expect(page).to have_link("Add to Cart")
    end
  end

  context "as a regular user" do
    it "has a link to add the item to the cart" do
      user = create(:user)
      login_as(user)
      visit item_path(@item)

      expect(page).to have_link("Add to Cart")
    end
  end

  context "as an admin" do
    it "does not have a link to add the item to the cart" do
      admin = create(:admin)
      login_as(admin)
      visit item_path(@item)

      expect(page).to_not have_link("Add to Cart")
    end
  end

  context "as an merchant" do
    it "does not have a link to add the item to the cart" do
      merchant = create(:merchant)
      login_as(merchant)
      visit item_path(@item)

      expect(page).to_not have_link("Add to Cart")
    end
  end
end