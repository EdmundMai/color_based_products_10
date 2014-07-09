require 'spec_helper'

describe PercentageCoupon do
  it_behaves_like "a coupon"
  
  describe "#apply_discount(order)" do    
    it "sets the difference of the old and new order.subtotal to order.savings" do
      order = Order.new(subtotal: 10.00)
      percentage_coupon = PercentageCoupon.new(value: 20.00)
      percentage_coupon.apply_discount(order)
      expect(order.savings).to eq(2.00)
    end
  end
  
  describe "#value_prettified" do
    it "returns a user friendly string to represent the percentage discount" do
      percentage_coupon = PercentageCoupon.new(value: 20.00)
      expect(percentage_coupon.value_prettified).to eq('20%')
    end
  end
end
