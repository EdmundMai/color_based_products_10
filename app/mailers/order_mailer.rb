class OrderMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def confirmation_email(order)
    @order = order
    mail(to: order.user.email)
  end
end
