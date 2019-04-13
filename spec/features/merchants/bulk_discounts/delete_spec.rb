require 'rails_helper'
RSpec.describe 'on the items index page' do
  describe 'i can delete a bulk discount' do
    it 'as a merchant I can delete a discount' do
      merchant = User.create(role:1, email: 'm2@gmail.com', active: true, name:"June's Produce", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 the road", password:"pw")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
      item1 = Item.create(name:'cinnamon', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      item2 = Item.create(name:'cloves', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      discount5 = item1.bulk_discounts.create(threshold:25, discount: 5)
      discount10 = item1.bulk_discounts.create(threshold:50, discount: 10)
      discount15 = item1.bulk_discounts.create(threshold:75, discount: 150)

      visit items_path

      within("#discount-#{discount15.id}") do
        click_on "Delete bulk discount"
      end
      expect(current_path).to eq(items_path)
      expect(page).to_not have_content(discount15.discount)
      expect(page).to_not have_content(discount15.threshold)
    end
    it 'as a registered user I cannot see the delete a discount link' do
      registered = User.create(role:0, email: 'v1@gmail.com', active: true, name:"Jud", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 hit the road", password:"pw")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(registered)
      merchant = User.create(role:1, email: 'm3@gmail.com', active: true, name:"June's Produce", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 the road", password:"pw")
      item1 = Item.create(name:'cinnamon', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      item2 = Item.create(name:'cloves', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      discount5 = item1.bulk_discounts.create(threshold:25, discount: 5)
      discount10 = item1.bulk_discounts.create(threshold:50, discount: 10)
      discount15 = item1.bulk_discounts.create(threshold:75, discount: 150)

      visit items_path

      expect(page).to_not have_content("Delete bulk discount")
    end
    it 'as a visitor I cannot see the delete a discount link' do
      # registered = User.create(role:0, email: 'v1@gmail.com', active: true, name:"Jud", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 hit the road", password:"pw")
      merchant = User.create(role:1, email: 'm3@gmail.com', active: true, name:"June's Produce", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 the road", password:"pw")
      item1 = Item.create(name:'cinnamon', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      item2 = Item.create(name:'cloves', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      discount5 = item1.bulk_discounts.create(threshold:25, discount: 5)
      discount10 = item1.bulk_discounts.create(threshold:50, discount: 10)
      discount15 = item1.bulk_discounts.create(threshold:75, discount: 150)

      visit items_path

      expect(page).to_not have_content("Delete bulk discount")
    end
  end
end
