class Color < ActiveRecord::Base
  mount_uploader :image, ColorUploader
  has_many :products_colors, dependent: :destroy
  validates_uniqueness_of :name

  default_scope { order("name ASC") }
end
