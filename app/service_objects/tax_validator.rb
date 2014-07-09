class TaxValidator
  include ActiveModel::Validations
  attr_reader :zip_code, :state_id
  
  def initialize(args={})
    @zip_code = args.fetch(:zip_code) { '' }
    @state_id = args.fetch(:state_id) { 0 }
  end
  
  def valid?
    if state_id && state_id == State.new_york.id
      tax = Tax.find_by(state_id: state_id, zip_code: zip_code)
      return true if tax
      
      errors[:base] << "The zip code you entered is invalid. Please try again."
      return false
    else
      true
    end
  end
  
end
