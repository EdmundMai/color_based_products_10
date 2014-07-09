require 'spec_helper'

describe Coupon do
  it_behaves_like "a coupon"
  
  describe ".active" do
    it "returns an array of coupons with start_date in the past and end_date in the future" do
      coupon = FactoryGirl.create(:free_shipping_coupon, start_date: Date.yesterday, end_date: Date.tomorrow)
      expect(Coupon.active).to match_array [coupon]
    end
    
    context "there are no active coupons" do
      it "returns an empty array" do
        expect(Coupon.active).to match_array []
      end
    end
  end
  
  describe ".site_wide" do
    it "returns all coupons with site_wide set to true" do
      coupon = FactoryGirl.create(:free_shipping_coupon, site_wide: true)
      expect(Coupon.site_wide).to match_array [coupon]
    end
  end
  
  describe "#apply_discount(order)" do
    it "raises an exception" do
      order = Order.new
      expect { Coupon.new.apply_discount(order) }.to raise_error(NoMethodError, "This method must be implemented in subclasses")
    end
  end
  
  describe "#value_prettified" do
    it "returns an empty string" do
      expect(Coupon.new.value_prettified).to eq('')
    end
  end
  
end
