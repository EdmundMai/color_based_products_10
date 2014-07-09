# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :flat_coupon do
    name "Flat!"
    code "BBB321"
    minimum_purchase_amount 6.33
    value 1.11
    start_date Date.yesterday
    end_date Date.tomorrow
  end
end
