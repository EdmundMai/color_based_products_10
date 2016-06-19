class Variant < ActiveRecord::Base
  monetize :list_price_cents, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10000 }
  monetize :discount_price_cents, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10000 }

  belongs_to :products_color
  belongs_to :size
  has_one :product, through: :products_color
  has_one :color, through: :products_color
  has_many :line_items

  def price
    discount_price && discount_price_cents != 0 ? discount_price : list_price
  end
end
