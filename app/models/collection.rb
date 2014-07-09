class Collection < ActiveRecord::Base
  default_scope { order('name ASC') }
  
  has_many :collections_products
  has_many :products, -> { order 'products.name' }, through: :collections_products
  
  scope :active, -> { where(active: true) }
end
