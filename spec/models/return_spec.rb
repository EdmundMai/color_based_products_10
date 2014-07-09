require 'spec_helper'

describe Return do
  its(:attributes) { should include("order_id") }
  its(:attributes) { should include("user_id") }
  its(:attributes) { should include("reason") }
  its(:attributes) { should include("status") }
  its(:attributes) { should include("rma_code") }
  its(:attributes) { should include("amount_cents") }
  its(:attributes) { should include("amount_currency") }
  its(:attributes) { should include("admin_comment") }
  
  it { should monetize(:amount_cents).with_currency(:usd) }
  
  it { should belong_to :order }
  it { should belong_to :user }
  it { should have_many :return_items }
  
  it { should accept_nested_attributes_for :return_items }
  
  it { should validate_presence_of :reason }
  it { should validate_presence_of :return_items }
  
  describe "#projected_amount" do
    it "returns the sum of the product of each return_item's quantity and their line_item's unit price" do
      order_return = FactoryGirl.build(:return, return_items: [])
      line_item = FactoryGirl.create(:line_item, unit_price: 11.11, quantity: 4)
      order_return.return_items << FactoryGirl.create(:return_item, line_item_id: line_item.id, quantity: 2)
      order_return.return_items << FactoryGirl.create(:return_item, line_item_id: line_item.id, quantity: 1)
      order_return.save
      expect(order_return.projected_amount).to eq(33.33)
    end
  end
  
  describe "#generate_rma_code" do
    it "populates the rma_code field with a random unique string" do
      order_return = Return.new
      order_return.generate_rma_code
      expect(order_return.rma_code).not_to be_nil
    end
  end
end
