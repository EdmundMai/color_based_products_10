class Return < ActiveRecord::Base
  PROCESSING = "Processing"
  RECEIVED = "Received"
  
  monetize :amount_cents
  
  belongs_to :order
  belongs_to :user
  has_many :return_items
  
  validates_presence_of :reason
  validates_presence_of :return_items
  
  accepts_nested_attributes_for :return_items
  
  def return_items_attributes=(attrs)
    attrs.each do |key, attributes|
      attrs.delete(key) if attributes[:chosen] == "0"
    end
    super(attrs)
  end
  
  def projected_amount
    return_items.inject(Money.new(0)) do |sum, return_item|
      sum + return_item.line_item.unit_price * return_item.quantity
    end
  end
  
  def generate_rma_code
    self.rma_code = loop do
      random_token = SecureRandom.hex(5)
      break random_token unless Return.exists?(rma_code: random_token)
    end
      
  end
  
end
