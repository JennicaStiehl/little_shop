require 'rails_helper'
RSpec.describe 'as a merchant' do
  describe 'I can add a bulk discount' do
    it 'which includes threshold, amount, etc' do
      merchant = User.create(role:1, email: 'm2@gmail.com', active: true, name:"June's Produce", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 the road", password:"pw")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
      Item.update_all(merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")

      item1 = Item.create(name:'cinnamon', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      item2 = Item.create(name:'cloves', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")

      discount =  10
      threshold =  50

      visit items_path
      within(".item-#{item1.id}") do
        click_on "Add bulk discount"
      end
      expect(current_path).to eq(new_merchants_item_bulk_discount_path(item1))

      fill_in 'bulk_discount[threshold]', with: threshold
      fill_in :Discount, with: discount
      click_on "Create Bulk discount"

      lastBD = BulkDiscount.last
      expect(current_path).to eq(items_path)
      expect(page).to have_content(lastBD.threshold)
      expect(page).to have_content(lastBD.discount)
    end
  end
end
