require 'rails_helper'
RSpec.describe 'as a merchant' do
  describe 'i can edit a bulk discount' do
    it 'with a form' do
      merchant = User.create(role:1, email: 'm2@gmail.com', active: true, name:"June's Produce", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 the road", password:"pw")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
      item1 = Item.create(name:'cinnamon', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      item2 = Item.create(name:'cloves', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      discount5 = item1.bulk_discounts.create(threshold:25, discount: 5)
      discount10 = item1.bulk_discounts.create(threshold:50, discount: 10)
      discount15 = item1.bulk_discounts.create(threshold:75, discount: 150)

      visit items_path

      within("#discount-#{discount15.id}") do
        click_on "Edit bulk discount"
      end
      expect(current_path).to eq(edit_merchants_item_bulk_discount_path(item1,discount15))
      (new_merchants_item_bulk_discount_path(item1))
      expect(page).to have_selector("input[value='#{discount15.discount}']")
      expect(page).to have_selector("input[value='#{discount15.threshold}']")
      fill_in 'bulk_discount[discount]', with: 15
      fill_in 'Threshold', with: 80
      click_on "Update Bulk discount"

      expect(current_path).to eq(items_path)
      expect(page).to have_content("Your item has been updated.")
      page.reset!
      visit items_path
      # page.reload
      bd = BulkDiscount.last
      expect(page).to have_content("Discount of $15 when you buy 80.")
      expect(page).to have_content(bd.discount)
    end
  end
end
