require 'rails_helper'

RSpec.describe "adding an item to the cart" do
  before :each do
    @merchant = User.create(slug: :email, role:1, email: 'm5@gmail.com', active: true, name:"June's Produce", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 the road", password:"pw")
    @item = Item.create(name:'cinnamon', active:true, price:2, description:"fresh", inventory: 20, merchant_id: @merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
    @item2 = Item.create(name:'cloves', active:true, price:2, description:"fresh", inventory: 20, merchant_id: @merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
    @discount5 = @item.bulk_discounts.create(threshold:50, discount: 10)
    @discount10 = @item.bulk_discounts.create(threshold:25, discount: 5)
    @discount15 = @item.bulk_discounts.create(threshold:12, discount: 2)
  end

  context "a visitor or regular user can add items to the cart" do
    before :each do
      @user = User.create(slug: :email, role:0, email: 'r3@gmail.com', active: true, name:"Jud", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 hit the road", password:"pw")
    end

    scenario "as a visitor" do
      visit item_path(@item)
    end

    scenario "as a regular user" do
      login_as(@user)
      visit item_path(@item)
    end

    after :each do
      visit item_path(@item)
      expect(page).to have_content("Cart: 0")
      click_on "Add to Cart"
      expect(page).to have_content("#{@item.name} has been added to your cart!")
      expect(page).to have_content("Cart: 1")
      visit item_path(@item)
      click_on "Add to Cart"
      expect(page).to have_content("#{@item.name} has been added to your cart!")
      expect(page).to have_content("Cart: 2")
      visit item_path(@item)
      click_on "Add to Cart"
      expect(page).to have_content("#{@item.name} has been added to your cart!")
      expect(page).to have_content("Cart: 3")
      visit item_path(@item)
      click_on "Add to Cart"
      expect(page).to have_content("#{@item.name} has been added to your cart!")
      expect(page).to have_content("Cart: 4")
      visit item_path(@item)
      click_on "Add to Cart"
      expect(page).to have_content("#{@item.name} has been added to your cart!")
      expect(page).to have_content("Cart: 5")
      visit item_path(@item)
      click_on "Add to Cart"
      expect(page).to have_content("#{@item.name} has been added to your cart!")
      expect(page).to have_content("Cart: 6")

      visit cart_path
      expect(page).to have_content("Discount of $2 when you spend $12.")
      expect(page).to have_content("Total: $10.")
    end
  end
end
