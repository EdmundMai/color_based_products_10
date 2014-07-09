# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    subtotal 5.43
    tax 3.12
    shipping 2.53
    total 12.34
    user
    
    factory :incomplete_order do
      status Order::INCOMPLETE
      shipping_address
      billing_address
      order_date Date.today
      after(:create) do |order, evaluator|
        order.line_items << FactoryGirl.create(:line_item)
      end
    end
    
    factory :in_progress_order do
      status Order::IN_PROGRESS
      shipping_address
      billing_address
      order_date Date.today
      after(:create) do |order, evaluator|
        order.line_items << FactoryGirl.create(:line_item)
      end
    end
    
    factory :shipped_order do
      order_date Date.today
      status Order::SHIPPED
      shipping_address
      billing_address
      after(:create) do |order, evaluator|
        order.line_items << FactoryGirl.create(:line_item)
      end
    end
  end
end
