# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :free_shipping_coupon do
    name "Free Shipping!"
    code "ABC123"
    minimum_purchase_amount 1.33
    start_date Date.yesterday
    end_date Date.tomorrow
  end
end
