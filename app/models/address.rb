class Address < ActiveRecord::Base
  belongs_to :state
  belongs_to :order
  
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :street_address
  validates_presence_of :street_address2
  validates_presence_of :zip_code
  validates_presence_of :city
  validates_presence_of :state_id
  validates_presence_of :phone_number
  
  def full_name
    [first_name, last_name].compact.join(" ")
  end
  
  def full_street_address
    [street_address, street_address2].compact.join(" ")
  end
  
  def city_state_zipcode
    "#{self.city}, #{self.state.short_name} #{self.zip_code}"
  end
end
