require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should validate_presence_of :description }
    it { should validate_presence_of :inventory }
    it { should validate_numericality_of(:inventory).only_integer }
    it { should validate_numericality_of(:inventory).is_greater_than_or_equal_to(0) }
  end

  describe 'relationships' do
    it { should belong_to :user }
  end

  describe 'class methods' do
    describe 'item popularity' do
      before :each do
        merchant = create(:merchant)
        @items = create_list(:item, 6, user: merchant)
        user = create(:user)

        order = create(:shipped_order, user: user)
        create(:fulfilled_order_item, order: order, item: @items[3], quantity: 7)
        create(:fulfilled_order_item, order: order, item: @items[1], quantity: 6)
        create(:fulfilled_order_item, order: order, item: @items[0], quantity: 5)
        create(:fulfilled_order_item, order: order, item: @items[2], quantity: 3)
        create(:fulfilled_order_item, order: order, item: @items[5], quantity: 2)
        create(:fulfilled_order_item, order: order, item: @items[4], quantity: 1)
      end

      it '.item_popularity' do
        expect(Item.item_popularity(4, :desc)).to eq([@items[3], @items[1], @items[0], @items[2]])
        expect(Item.item_popularity(4, :asc)).to eq([@items[4], @items[5], @items[2], @items[0]])
      end

      it '.popular_items' do
        actual = Item.popular_items(3)
        expect(actual).to eq([@items[3], @items[1], @items[0]])
        expect(actual[0].total_ordered).to eq(7)
      end

      it '.unpopular_items' do
        actual = Item.unpopular_items(3)
        expect(actual).to eq([@items[4], @items[5], @items[2]])
        expect(actual[0].total_ordered).to eq(1)
      end
    end

    it '.can get all discounts asoc with one item' do
      merchant = User.create(role:1, email: 'm3@gmail.com', active: true, name:"June's Produce", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 the road", password:"pw")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
      item1 = Item.create(name:'cinnamon', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      item2 = Item.create(name:'cloves', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      discount5 = item1.bulk_discounts.create(threshold:25, discount: 5)
      discount10 = item1.bulk_discounts.create(threshold:50, discount: 10)
      discount15 = item1.bulk_discounts.create(threshold:75, discount: 150)
      item2discount5 = item2.bulk_discounts.create(threshold:25, discount: 5)
      actual = item1.all_discounts.count
      expect(actual).to eq(3)
    end
    it 'can find the best discount per item' do
      merchant = User.create(role:1, email: 'm3@gmail.com', active: true, name:"June's Produce", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 the road", password:"pw")
      item1 = Item.create(name:'cinnamon', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      discount5 = item1.bulk_discounts.create(threshold:25, discount: 5)
      discount10 = item1.bulk_discounts.create(threshold:50, discount: 10)
      discount15 = item1.bulk_discounts.create(threshold:75, discount: 150)
      actual = item1.best_discount
      expect(actual).to eq(150)
      actual2 = item1.avg_discount
      expect(actual2).to eq(0.55e2)
    end
    it 'does not find the discount from another item while findiing the best discount' do
      merchant = User.create(role:1, email: 'm3@gmail.com', active: true, name:"June's Produce", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 the road", password:"pw")
      item1 = Item.create(name:'cinnamon', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      item2 = Item.create(name:'cloves', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
      discount5 = item1.bulk_discounts.create(threshold:25, discount: 5)
      discount10 = item1.bulk_discounts.create(threshold:50, discount: 10)
      discount15 = item1.bulk_discounts.create(threshold:75, discount: 150)
      item2discount5 = item2.bulk_discounts.create(threshold:25, discount: 5)
      actual = item1.best_discount
      expect(actual).to_not eq(25)
    end
  end

  describe 'instance methods' do
    before :each do
      @merchant = create(:merchant)
      @user = User.create(email:"dsf@sad", password:"sdf", role:0, active:true, name:"sid",address:"asd", city:"asd", state:"as",zip:47589)
      @item = @merchant.items.create(price:3,inventory:30, name:"widget", active:true, image:"sdf.jpeg", description:"real stuff")
      @order = Order.create(user_id:@user, status:0)
      @order_item_1 = create(:fulfilled_order_item, item: @item, created_at: 4.days.ago, updated_at: 12.hours.ago)
      @order_item_2 = create(:fulfilled_order_item, item: @item, created_at: 2.days.ago, updated_at: 1.day.ago)
      @order_item_3 = create(:fulfilled_order_item, item: @item, created_at: 2.days.ago, updated_at: 1.day.ago)
      @order_item_4 = OrderItem.create(item: @item, order: @order, price: 3, quantity: 6, created_at: 2.days.ago, updated_at: 1.day.ago)
      @cart = Cart.new({"1" => 3, "4" => 2})
      @cart_2 = Cart.new({"1" => 6, "4" => 2})
      @cart_3 = Cart.new({"1" => 12, "4" => 2})
    end

    describe "#average_fulfillment_time" do
      it "calculates the average number of seconds between order_item creation and completion" do
        expect(@item.average_fulfillment_time).to eq(158400)
      end

      it "returns nil when there are no order_items" do
        unfulfilled_item = create(:item, user: @merchant)
        unfulfilled_order_item = create(:order_item, item: @item, created_at: 2.days.ago, updated_at: 1.day.ago)

        expect(unfulfilled_item.average_fulfillment_time).to be_falsy
      end
    end

    describe "#ordered?" do
      it "returns true if an item has been ordered" do
        expect(@item.ordered?).to be_truthy
      end

      it "returns false when the item has never been ordered" do
        unordered_item = create(:item)
        expect(unordered_item.ordered?).to be_falsy
      end
    end
    describe "#apply_discount(item)" do
      it 'can find return nil when there isnt an appropriate discount' do
        discount2 = @item.bulk_discounts.create(threshold:12, discount: 2)
        actual = @cart_2.apply_discount(@item)
        expect(actual).to eq(0.0)
      end
    end
  end
  describe 'more instance methods with new examples' do

    describe "#find_discount" do
      it 'can find return nil when there isnt an appropriate discount' do
        merchant = User.create(role:1, email: 'm3@gmail.com', active: true, name:"June's Produce", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 the road", password:"pw")
        item1 = Item.create(name:'cinnamon', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
        item2 = Item.create(name:'cloves', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
        discount5 = item1.bulk_discounts.create(threshold:20, discount: 5)
        discount10 = item1.bulk_discounts.create(threshold:50, discount: 10)
        discount15 = item1.bulk_discounts.create(threshold:75, discount: 150)
        item2discount5 = item2.bulk_discounts.create(threshold:25, discount: 5)
        discount2 = item1.bulk_discounts.create(threshold:6, discount: 2)
        cart = Cart.new({"#{item1.id}" => 2, "#{item2.id}" => 2})
        discount = cart.items.each do |item, quantity|
            item = Item.find(item.id)
            cart.find_discount(item1)
        end
        actual = cart.find_discount(item1)
        expect(actual).to eq(nil)
      end
      
      it 'can find the appropriate discount' do
        merchant = User.create!(role:1, email: 'm3@gmail.com', active: true, name:"June's Produce", created_at: 10.days.ago, updated_at: 1.days.ago, city:"Denver", state:"CO", zip: 80209, address:"123 the road", password:"pw")
        item1 = Item.create!(name:'cinnamon', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
        item2 = Item.create!(name:'cloves', active:true, price:2.5, description:"fresh", inventory: 20, merchant_id: merchant.id, image: "https://www.continuumcolo.org/wp-content/uploads/2016/03/Image-Coming-Soon-Placeholder-300x300.png")
        discount5 = item1.bulk_discounts.create!(threshold:20, discount: 5)
        discount10 = item1.bulk_discounts.create!(threshold:50, discount: 10)
        discount15 = item1.bulk_discounts.create!(threshold:75, discount: 150)
        item2discount5 = item2.bulk_discounts.create!(threshold:25, discount: 5)
        cart = Cart.new({"#{item1.id}" => 12, "#{item2.id}" => 2})

        actual = cart.find_discount(item1)
        # binding.pry
        expect(actual.discount).to eq(discount5.discount)
        expect(actual.threshold).to eq(discount5.threshold)
      end
    end
  end
end
