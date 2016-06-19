class ReturnItem < ActiveRecord::Base
  belongs_to :return
  belongs_to :line_item

  attr_accessor :chosen
end
