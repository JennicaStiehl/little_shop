require 'rails_helper'
RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to :item }
  end
  # describe 'enum' do
  #   it 'can assign the correct index' do
  #     merchant = User.create(role:1, email: 'm1@gmail.com', active: true)
  #     item = Item.create(name:'cinnamon', active:true, price:2.5, description:"fresh", inventory: 20, user:merchant)
  #     bd = BulkDiscount.create(discount: 10, discount_type:1, threshold: 50, item:item)
  #     actual = bd.discount_type
  #     expect(actual).to eq('dollar')
  #   end
end
