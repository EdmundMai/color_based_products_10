require 'spec_helper'

describe Variant do
  its(:attributes) { should include("products_color_id") }
  its(:attributes) { should include("measurements") }
  its(:attributes) { should include("weight") }
  its(:attributes) { should include("size_id") }
  its(:attributes) { should include("list_price_cents") }
  its(:attributes) { should include("list_price_currency") }
  its(:attributes) { should include("discount_price_cents") }
  its(:attributes) { should include("discount_price_currency") }
  its(:attributes) { should include("sku") }
  its(:attributes) { should include("in_stock") }

  
  context "list_price and discount_price and set" do
    subject { Variant.new(list_price: 1, discount_price: 2)}
    it { should monetize(:list_price_cents).with_currency(:usd) }
    it { should monetize(:discount_price_cents).with_currency(:usd) }
  end

  it { should belong_to(:products_color) }
  it { should belong_to(:size) }
  
  it { should have_one(:product).through(:products_color) }
  it { should have_one(:color).through(:products_color) }
  
  it { should have_many(:line_items) }
  
  context "prices are set" do
    subject { Variant.new(discount_price: 11.22, list_price: 33.33)}
    it { should monetize(:list_price_cents).with_currency(:usd) }
    it { should monetize(:discount_price_cents).with_currency(:usd) }
  end
  
  
  describe "#price" do
    context "discount_price exists and != 0" do
      it "returns the discount_price" do
        variant = Variant.new(discount_price: 11.22)
        expect(variant.price).to eq(Money.new(1122, "USD"))
      end
    end
    context "discount_price does not exist" do
      it "returns the list_price" do
        variant = Variant.new(list_price: 11.22)
        expect(variant.price).to eq(Money.new(1122, "USD"))
      end
    end
  end
  
end
