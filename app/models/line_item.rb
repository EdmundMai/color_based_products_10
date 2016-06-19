class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :variant
  monetize :unit_price_cents

  has_many :return_items

  def returnable_quantity
    if return_items.present?
      quantity - return_items.map(&:quantity).reduce(:+)
    else
      quantity
    end
  end
end
