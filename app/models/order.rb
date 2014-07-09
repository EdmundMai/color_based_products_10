class Order < ActiveRecord::Base
  
  INCOMPLETE = 'Incomplete'
  IN_PROGRESS = 'In progress'
  SHIPPED = 'Shipped'
  CANCELLED = 'Cancelled'
  
  belongs_to :coupon
  belongs_to :user
  has_one :shipping_address, dependent: :destroy
  has_one :billing_address, dependent: :destroy

  has_many :line_items, dependent: :destroy
  
  monetize :savings_cents
  monetize :total_cents
  monetize :tax_cents
  monetize :subtotal_cents
  monetize :shipping_cents
  
  scope :in_progress_or_shipped, -> { where(status: [Order::IN_PROGRESS, Order::SHIPPED]).order("order_date ASC") }

  
  def return_threshold_passed?
    return true if order_date.nil?
    
    order_date < 31.days.ago
  end
  
  def attach_coupon!(coupon)
    update_attributes!(coupon_id: coupon.id)
  end
  
  def self.status_options
    [IN_PROGRESS, SHIPPED, CANCELLED]
  end
  
  def has_no_more_items_to_return?
    line_items.map(&:returnable_quantity).reduce(:+) == 0
  end
  
  def update_all_fees!
    #it must be in this order
    calculate_subtotal
    calculate_shipping
    calculate_coupon_discount
    calculate_tax
    calculate_total
    save!
  end
  
  def finalize!
    user.cart.cart_items.each do |cart_item|
      line_item = LineItem.new(cart_item.attributes.except("id", "cart_id"))
      line_item.unit_price = cart_item.variant.price
      line_item.order_id = self.id
      self.line_items << line_item
    end
    OrderMailer.confirmation_email(self).deliver
    set_status_to_in_progress
    set_order_date_to_today
    save
    user.cart.empty!
  end
  
  def set_order_date_to_today
    self.order_date = Date.today
  end
  
  def set_status_to_in_progress
    self.update_attributes!(status: IN_PROGRESS)
  end
  
  def calculate_subtotal
    self.subtotal = user.cart.total
  end
  
  def calculate_shipping
    0
  end
  
  def calculate_coupon_discount
    coupon.apply_discount(self) if coupon
  end
  
  def calculate_tax
    if self.shipping_address.state && self.shipping_address.state == State.new_york
      corresponding_tax = Tax.find_by(zip_code: self.shipping_address.zip_code, state_id: self.shipping_address.state_id)
      self.tax = corresponding_tax.rate * (self.subtotal + shipping)
    else
      self.tax = 0.00
    end
  end
  
  def calculate_total
    self.total = self.subtotal + self.shipping + self.tax - self.savings
  end
  
  
end
