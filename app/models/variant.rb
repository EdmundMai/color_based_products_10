class Variant < ActiveRecord::Base
  monetize :list_price_cents, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10000 }
  monetize :discount_price_cents, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10000 }
  
  belongs_to :products_color
  
  has_one :product, through: :products_color
  has_one :color, through: :products_color
  
  has_many :line_items
  
  belongs_to :size

  
  def price
    discount_price && discount_price_cents != 0 ? discount_price : list_price
  end
  
end
