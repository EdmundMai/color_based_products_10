require 'spec_helper'

describe ApplicationHelper do
  include ApplicationHelper

  describe ".vendor_options_with_extra_link_to_create_vendor" do
    it "returns an option for each vendor, and one for creating a new vendor" do
      vendor = FactoryGirl.create(:vendor)
      expect(vendor_options_with_extra_link_to_create_vendor).to include "<option value=\"#{vendor.id}\">#{vendor.name}</option>"
      expect(vendor_options_with_extra_link_to_create_vendor).to include "<option value='' id='new_vendor_option'>Create a new vendor...</option>"
    end
  end
  
  describe ".color_options_with_extra_link_to_create_color" do
    it "returns an option for each color, and one for creating a new color" do
      color = FactoryGirl.create(:color)
      expect(color_options_with_extra_link_to_create_color).to include "<option value=\"#{color.id}\">#{color.name}</option>"
      expect(color_options_with_extra_link_to_create_color).to include "<option value='' id='new_color_option'>Create a new color...</option>"
    end
  end
  
  describe ".shape_options_with_extra_link_to_create_shape" do
    it "returns an option for each shape, and one for creating a new shape" do
      shape = FactoryGirl.create(:shape)
      expect(shape_options_with_extra_link_to_create_shape).to include "<option value=\"#{shape.id}\">#{shape.name}</option>"
      expect(shape_options_with_extra_link_to_create_shape).to include "<option value='' id='new_shape_option'>Create a new shape...</option>"
    end
  end
  
  describe ".material_options_with_extra_link_to_create_material" do
    it "returns an option for each material, and one for creating a new material" do
      material = FactoryGirl.create(:material)
      expect(material_options_with_extra_link_to_create_material).to include "<option value=\"#{material.id}\">#{material.name}</option>"
      expect(material_options_with_extra_link_to_create_material).to include "<option value='' id='new_material_option'>Create a new material...</option>"
    end
  end
  
  describe ".order_qualifies_for_coupon?(order, coupon)" do
    context "order meets requirements for coupon" do
      it "returns true" do
        order = Order.new
        order.stub_chain(:user, :cart, :total).and_return(Money.new(999.99))
        coupon = Coupon.new(minimum_purchase_amount: 1.00, start_date: Date.yesterday, end_date: Date.tomorrow)
        expect(order_qualifies_for_coupon?(order, coupon)).to be_true
      end
    end
    
    context "order does not meet requirements for coupon" do
      it "returns false" do
        order = Order.new
        order.stub_chain(:user, :cart, :total).and_return(Money.new(1.00))
        coupon = Coupon.new(minimum_purchase_amount: 999.99, start_date: Date.yesterday, end_date: Date.tomorrow)
        expect(order_qualifies_for_coupon?(order, coupon)).to be_false
      end
    end
  end
  
  
end