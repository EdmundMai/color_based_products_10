class CouponValidator
  include ActiveModel::Validations
  attr_reader :coupon, :order, :coupon_code_entered
  
  def initialize(args={})
    @coupon = args[:coupon]
    @coupon_code_entered = args[:coupon_code_entered]
    @order = args.fetch(:order) { raise ArgumentError, "Order was not provided." }
  end
  
  def valid?
    return true if !coupon_code_entered
    if coupon.nil?
      errors[:base] << "Please enter a valid coupon code." 
    else
      errors[:base] << "The coupon you entered is inactive." if coupon.start_date > Date.today
      errors[:base] << "The coupon you entered is expired." if coupon.end_date < Date.today
      errors[:base] << "Your order does not meet the minimum purchase amount for this coupon." if order.user.cart.total < coupon.minimum_purchase_amount
    end
    errors.empty? ? true : false
  end
  
end