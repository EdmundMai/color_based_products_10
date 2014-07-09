require "spec_helper"

describe OrderMailer do
  
  describe "#confirmation_email(order)" do
    let(:order) { FactoryGirl.create(:shipped_order) }
    
    before do
      OrderMailer.confirmation_email(order).deliver
    end
    
    subject { ActionMailer::Base.deliveries.first }
    
    its(:to) { should match_array [order.user.email] }
    its(:body) { should include order.id }
    its(:body) { should include order.user.email }
  end
  
end
