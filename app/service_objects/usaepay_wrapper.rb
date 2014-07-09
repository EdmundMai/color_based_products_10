require 'usaepay'
class UsaepayWrapper 
  extend Forwardable
  
  def_delegators :@transaction, :result, :error
  
  attr_reader :transaction
  
  def initialize(args={})
    @transaction = UmTransaction.new
    # These two attributes need to get set for USAePay to work:
    # These credentials will differ between the sandbox and production accounts
    # @transaction.key="Your_source_key_here"
    # @transaction.pin="1234"
    
    #sign up for a sandbox test account here: https://www.usaepay.com/developer/
    # more details on this page: http://wiki.usaepay.com/developer/sandbox
    @transaction.usesandbox = true unless Rails.env.production?
    @transaction.command = "authonly"
    
    @transaction.card = args.fetch(:credit_card_number) { '' }
    @transaction.cvv2 = args.fetch(:credit_card_cvv) { '' }
    @transaction.exp = mmyy_format(args[:credit_card_exp_mm], args[:credit_card_exp_yyyy])
    
    order_id = args.fetch(:order_id) { :order_was_not_provided }
    order = Order.find(order_id)
    @transaction.invoice = order.id
    @transaction.cardholder = order.billing_address.full_name
    @transaction.street = order.billing_address.full_street_address
    @transaction.zip = order.billing_address.zip_code
    @transaction.amount = order.total.to_s
    
    @transaction.pin="1234"
  end
  
  
  def authorize
    # @transaction.process
    # @transaction.resultcode.first == "A"
    true
  end

  
  private
  
    def mmyy_format(mm, yyyy)
      ('%02d' % mm) + yyyy[-2..-1]
    rescue
      Date.today.strftime("%m%y")
    end
    
end
