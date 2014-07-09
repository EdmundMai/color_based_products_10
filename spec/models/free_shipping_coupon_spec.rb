require 'spec_helper'

describe FreeShippingCoupon do
  it_behaves_like "a coupon"
  
  describe "before_save" do
    it "sets value to 0" do
      free_shipping_coupon = FactoryGirl.build(:free_shipping_coupon, value: 99.99)
      free_shipping_coupon.save
      expect(free_shipping_coupon.value).to eq(0.00)
    end
  end
  
  describe "#apply_discount(order)" do
    it "sets the order savings to the shipping cost" do
      order = Order.new(shipping: 12.22)
      FreeShippingCoupon.new.apply_discount(order)
      expect(order.savings).to eq(12.22)
    end
  end
  
  describe "#value_prettified" do
    it "returns 'Free Shipping'" do
      expect(FreeShippingCoupon.new.value_prettified).to eq('Free Shipping')
    end
  end
end
