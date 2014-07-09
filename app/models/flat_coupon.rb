class FlatCoupon < Coupon
  
  validates :minimum_purchase_amount, numericality: { greater_than: :value, message: "must be more than the discount amount." },
            if: Proc.new { |c| c.value.present? }

  
  def apply_discount(order)
    order.savings = self.value
  end
  
  def value_prettified
    "$#{"%0.2f" % self.value.to_f}"
  end
  
end
