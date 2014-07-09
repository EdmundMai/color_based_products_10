require 'spec_helper'

describe User do
  its(:attributes) { should include("email") }
  its(:attributes) { should include("guest") }
  its(:attributes) { should include("guest_email") }
  its(:attributes) { should include("encrypted_password") }
  
  it { should have_many(:returns) }
  it { should have_many(:orders) }
  it { should have_one(:cart).dependent(:destroy) }
  

  
  describe "#registered_email" do
    context "user is guest" do
      it "returns guest_email" do
        user = User.new(guest: true, guest_email: "abc123@yahoo.com")
        expect(user.registered_email).to eq("abc123@yahoo.com")
      end
    end
    context "user is not a guest" do
      it "returns email" do
        user = User.new(guest: false, email: "abc123@yahoo.com")
        expect(user.registered_email).to eq("abc123@yahoo.com")
      end
    end
  end
  
  describe "after create callbacks" do
    let(:user) { User.new(email: "test123@testing.com", password: 'test123') }
    it "associates a new cart to the user" do
      user.save
      user.cart.should_not be_nil
    end
  end
  
  describe "#last_complete_order" do
    context "a order with status #{Order::IN_PROGRESS} for the user exists" do
      it "returns the last complete order made by the user" do
        user = FactoryGirl.create(:user)
        complete_order = FactoryGirl.create(:order, status: Order::IN_PROGRESS, user_id: user.id)
        expect(user.last_complete_order).to eq(complete_order)
      end
    end
    context "a order with status #{Order::SHIPPED} for the user exists" do
      it "returns the last complete order made by the user" do
        user = FactoryGirl.create(:user)
        complete_order = FactoryGirl.create(:order, status: Order::SHIPPED, user_id: user.id)
        expect(user.last_complete_order).to eq(complete_order)
      end
    end
    
    context "a complete order for the user does not exist" do
      it "returns nil" do
        user = FactoryGirl.create(:user)
        expect(user.last_complete_order).to be_nil
      end
    end
  end
  
  describe "#last_incomplete_order" do
    context "an incomplete order for the user exists" do
      it "returns the last order of the user marked incomplete" do
        user = FactoryGirl.create(:user)
        incomplete_order = FactoryGirl.create(:order, status: Order::INCOMPLETE)
        user.orders << incomplete_order
        expect(user.last_incomplete_order).to eq(incomplete_order)
      end
    end
    
    context "no incomplete orders exist for the user" do
      it "returns a order for the user with status incomplete" do
        user = FactoryGirl.create(:user)
        expect(user.last_incomplete_order.status).to eq Order::INCOMPLETE
      end
      
      it "returns a order for the user with user == self" do
        user = FactoryGirl.create(:user)
        expect(user.last_incomplete_order.user).to eq user
      end
      
      it "returns a new order for the user" do
        user = FactoryGirl.create(:user)
        expect(user.orders.count).to eq(0)
        expect{user.last_incomplete_order}.to change{Order.count}.by(1)
      end
    end
  end
  
  describe "#past_orders" do
    it "returns an array of orders that have status #{Order::IN_PROGRESS} or #{Order::SHIPPED} associated with that user" do
      user = FactoryGirl.create(:user)
      shipped_order = FactoryGirl.create(:shipped_order, user: user)
      in_progress_order = FactoryGirl.create(:in_progress_order, user: user)
      incomplete_order = FactoryGirl.create(:incomplete_order, user: user)
      
      user.orders << shipped_order
      user.orders << in_progress_order
      user.orders << incomplete_order
      
      expect(user.past_orders).to match_array [shipped_order, in_progress_order]
    end
  end
end
