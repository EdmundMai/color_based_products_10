class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  has_one :cart, dependent: :destroy
  has_many :orders
  has_many :returns

  validates_format_of :email, :with  => Devise.email_regexp, if: Proc.new { |u| !u.guest? }
  validates :email, :presence => true, :uniqueness => true, if: ->(u) { !u.guest }
  validates_length_of :password, :within => Devise.password_length, :allow_blank => true, if: Proc.new { |u| !u.guest? }
  validates_format_of :guest_email, :with  => Devise.email_regexp, if: Proc.new { |u| u.guest? }
  validates_presence_of   :password, :on=>:create
  validates_confirmation_of   :password, :on=>:create

  after_create :create_cart!

  def last_incomplete_order
    self.orders.where(status: Order::INCOMPLETE).first_or_create
  end

  def last_complete_order
    past_orders.last
  end

  def past_orders
    self.orders.in_progress_or_shipped
  end

  def create_cart!
    self.cart = Cart.new(user_id: self.id)
    self.cart.save
  end

  def registered_email
    guest ? guest_email : email
  end
end
