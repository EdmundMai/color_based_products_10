require 'spec_helper'

describe FlatCoupon do
  it_behaves_like "a coupon"
  
  describe "validations" do
    it "validates that the minimum_purchase_amount is less than the value" do
      flat_coupon = FlatCoupon.new(minimum_purchase_amount: 1.00, value: 2.00)
      expect(flat_coupon).not_to be_valid
      expect(flat_coupon.errors.full_messages).to include "Minimum purchase amount must be more than the discount amount."
    end
  end
  
  describe "#apply_discount(order)" do    
    it "sets order.savings equal to self.value" do
      order = Order.new(subtotal: 10.00)
      flat_coupon = FlatCoupon.new(minimum_purchase_amount: 1.00, value: 2.00)
      flat_coupon.apply_discount(order)
      expect(order.savings).to eq(2.00)
    end
  end
  
  describe "#value_prettified" do
    it "returns a user friendly string to represent the flat discount amount" do
      flat_coupon = FlatCoupon.new(minimum_purchase_amount: 1.00, value: 2.00)
      expect(flat_coupon.value_prettified).to eq("$2.00")
    end
  end

  
end
