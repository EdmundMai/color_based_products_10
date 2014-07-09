class Coupon < ActiveRecord::Base
  monetize :minimum_purchase_amount_cents
  
  has_many :orders
  
  validates_uniqueness_of :code
  validates_presence_of :code
  validates_presence_of :start_date
  validates_presence_of :end_date
  validate :start_date_is_before_end_date
  
  
  scope :active, -> { where("DATE(start_date) <= ? AND DATE(end_date) >= ?", Date.today, Date.today) }
  scope :site_wide, -> { where(site_wide: true) }
  
  def apply_discount(order)
    raise NoMethodError, "This method must be implemented in subclasses"
  end
  
  def value_prettified
    ''
  end
  
  private
    
  def start_date_is_before_end_date
    return if start_date.blank? || end_date.blank?
    
    if start_date > end_date
      errors.add(:end_date, "must be after the start date.")
    end
  end
  
end
