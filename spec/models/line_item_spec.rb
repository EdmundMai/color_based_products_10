require 'spec_helper'

describe LineItem do
  its(:attributes) { should include("order_id") }
  its(:attributes) { should include("quantity") }
  its(:attributes) { should include("variant_id") }
  its(:attributes) { should include("unit_price_cents") }
  its(:attributes) { should include("unit_price_currency") }
  it { should belong_to(:order) }
  it { should belong_to(:variant) }
  it { should monetize(:unit_price_cents).with_currency(:usd) }  
  
  it { should have_many :return_items }
  
  describe "returnable_quantity" do
    context "return_items for the line_item exists" do
      it "returns self.quantity - the sum of all the quantities of every associated return_item" do
        line_item = FactoryGirl.create(:line_item, quantity: 5)
        line_item.return_items << FactoryGirl.create(:return_item, quantity: 1)
        line_item.return_items << FactoryGirl.create(:return_item, quantity: 2)
        expect(line_item.returnable_quantity).to eq(2)
      end
    end
    
    context "return_items for the line_item do not exist" do
      it "returns self.quantity" do
        line_item = FactoryGirl.create(:line_item, quantity: 5)
        expect(line_item.returnable_quantity).to eq(5)
      end
    end
  end
  
end
