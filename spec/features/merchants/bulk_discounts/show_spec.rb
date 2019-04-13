require 'rails_helper'
RSpec.describe 'on the discount show page' do
  describe 'i can see a bulk discounts details' do
    it 'as a merchant I can delete or edit a discount' do
      merchant = User.create(role:1, email: 'm2@gmail.com', active: true, name:"June's Produce", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 the road", password:"pw")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
      item1 = Item.create(name:'cinnamon', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      item2 = Item.create(name:'cloves', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      discount5 = item1.bulk_discounts.create(threshold:25, discount: 5)
      discount10 = item1.bulk_discounts.create(threshold:50, discount: 10)
      discount15 = item1.bulk_discounts.create(threshold:75, discount: 150)

      visit merchants_item_bulk_discount_path(item1,discount15)
      expect(page).to have_content(discount15.discount)
      expect(page).to have_content(discount15.threshold)
      expect(page).to have_content("Delete bulk discount")
      expect(page).to have_content("Edit bulk discount")
    end
    it 'as a visitor I cannot see the delete or edit links' do
      merchant = User.create(role:1, email: 'm2@gmail.com', active: true, name:"June's Produce", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 the road", password:"pw")
      item1 = Item.create(name:'cinnamon', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      item2 = Item.create(name:'cloves', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      discount5 = item1.bulk_discounts.create(threshold:25, discount: 5)
      discount10 = item1.bulk_discounts.create(threshold:50, discount: 10)
      discount15 = item1.bulk_discounts.create(threshold:75, discount: 150)

      visit merchants_item_bulk_discount_path(item1,discount15)
      expect(page).to have_content(discount15.discount)
      expect(page).to have_content(discount15.threshold)
      expect(page).to_not have_content("Delete bulk discount")
      expect(page).to_not have_content("Edit bulk discount")
    end
  end
end
