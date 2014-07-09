require 'spec_helper'

describe CouponValidator do
  
  describe "initialize(args)" do
    context "coupon key is supplied" do
      it "sets the coupon attribute" do
        coupon = Coupon.new
        order = Order.new
        coupon_validator = CouponValidator.new(coupon: coupon, order: order)
        expect(coupon_validator.coupon).to eq(coupon)
      end
    end
    
    context "coupon_code_entered key is supplied" do
      it "sets the coupon_code_entered value" do
        order = Order.new
        coupon_validator = CouponValidator.new(coupon_code_entered: true, order: order)
        expect(coupon_validator.coupon_code_entered).to be_true
      end
    end
    
    context "order key is supplied" do
      it "sets the order attribute" do
        order = Order.new
        coupon_validator = CouponValidator.new(order: order)
        expect(coupon_validator.order).to eq(order)
      end
    end
    context "order key is not provided" do
      it "raises an error" do
        expect { CouponValidator.new }.to raise_error(ArgumentError, "Order was not provided.")
      end
    end
  end
  
  describe "#valid?" do    
    context "coupon_code_entered is false" do
      it "returns true" do
        order = Order.new(subtotal: 999.99)
        coupon_validator = CouponValidator.new(coupon_code_entered: false, order: order)
        expect(coupon_validator.valid?).to be_true
      end
    end
    
    context "coupon_code_entered is true" do
      context "coupon is nil" do
        it "returns false" do
          order = Order.new(subtotal: 999.99)
          coupon_validator = CouponValidator.new(coupon_code_entered: true, order: order, coupon: nil)
          expect(coupon_validator.valid?).to be_false
        end
        
        it "adds an error" do
          order = Order.new(subtotal: 999.99)
          coupon_validator = CouponValidator.new(coupon_code_entered: true, order: order, coupon: nil)
          coupon_validator.valid?
          expect(coupon_validator.errors.full_messages).to include "Please enter a valid coupon code."
        end
      end
      
      context "today's date is before coupon.start_date" do
        it "returns false" do
          order = Order.new
          order.stub_chain(:user, :cart, :total).and_return(Money.new(10000))
          coupon = Coupon.new(start_date: Date.tomorrow, end_date: 1.month.from_now, minimum_purchase_amount: 1.00)
          coupon_validator = CouponValidator.new(coupon_code_entered: true, coupon: coupon, order: order)
          expect(coupon_validator.valid?).to be_false
        end
        it "adds an error" do
          order = Order.new
          order.stub_chain(:user, :cart, :total).and_return(Money.new(10000))
          coupon = Coupon.new(start_date: Date.tomorrow, end_date: 1.month.from_now, minimum_purchase_amount: 1.00)
          coupon_validator = CouponValidator.new(coupon_code_entered: true, coupon: coupon, order: order)
          coupon_validator.valid?
          expect(coupon_validator.errors.full_messages).to include "The coupon you entered is inactive."
        end
      end
    
      context "today's date is past coupon.end_date" do
        it "returns false" do
          order = Order.new
          order.stub_chain(:user, :cart, :total).and_return(Money.new(10000))
          coupon = Coupon.new(start_date: Date.yesterday, end_date: Date.yesterday, minimum_purchase_amount: 1.00)
          coupon_validator = CouponValidator.new(coupon_code_entered: true, coupon: coupon, order: order)
          expect(coupon_validator.valid?).to be_false
        end
        it "adds an error" do
          order = Order.new
          order.stub_chain(:user, :cart, :total).and_return(Money.new(10000))
          coupon = Coupon.new(start_date: Date.yesterday, end_date: Date.yesterday, minimum_purchase_amount: 1.00)
          coupon_validator = CouponValidator.new(coupon_code_entered: true, coupon: coupon, order: order)
          coupon_validator.valid?
          expect(coupon_validator.errors.full_messages).to include "The coupon you entered is expired."
        end
      end
      context "today's date is not past the end_date" do
        it "returns true" do
          order = Order.new
          order.stub_chain(:user, :cart, :total).and_return(Money.new(10000))
          coupon = Coupon.new(start_date: Date.yesterday, end_date: Date.tomorrow, minimum_purchase_amount: 1.00)
          coupon_validator = CouponValidator.new(coupon_code_entered: true, coupon: coupon, order: order)
          expect(coupon_validator.valid?).to be_true
        end
      end
      context "the end_date is today" do
        it "returns true" do
          order = Order.new
          order.stub_chain(:user, :cart, :total).and_return(Money.new(10000))
          coupon = Coupon.new(start_date: Date.yesterday, end_date: Date.today, minimum_purchase_amount: 1.00)
          coupon_validator = CouponValidator.new(coupon_code_entered: true, coupon: coupon, order: order)
          expect(coupon_validator.valid?).to be_true
        end
      end
      context "order.user.cart.total is less than the minimum_purchase_amount" do
        it "returns false" do
          order = Order.new
          order.stub_chain(:user, :cart, :total).and_return(Money.new(999))
          coupon = Coupon.new(start_date: Date.yesterday, end_date: Date.tomorrow, minimum_purchase_amount: 10.00)
          coupon_validator = CouponValidator.new(coupon_code_entered: true, coupon: coupon, order: order)
          expect(coupon_validator.valid?).to be_false
        end
        it "adds an error" do
          order = Order.new
          order.stub_chain(:user, :cart, :total).and_return(Money.new(999))
          coupon = Coupon.new(start_date: Date.yesterday, end_date: Date.tomorrow, minimum_purchase_amount: 10.00)
          coupon_validator = CouponValidator.new(coupon_code_entered: true, coupon: coupon, order: order)
          coupon_validator.valid?
          expect(coupon_validator.errors.full_messages).to include "Your order does not meet the minimum purchase amount for this coupon."
        end
      end
      context "order.user.cart.total is equal to the minimum_purchase_amount" do
        it "returns true" do
          order = Order.new
          order.stub_chain(:user, :cart, :total).and_return(Money.new(999))
          coupon = Coupon.new(start_date: Date.yesterday, end_date: Date.tomorrow, minimum_purchase_amount: 9.99)
          coupon_validator = CouponValidator.new(coupon_code_entered: true, coupon: coupon, order: order)
          expect(coupon_validator.valid?).to be_true
        end
      end
    end
  end  
end