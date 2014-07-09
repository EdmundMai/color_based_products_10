# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :percentage_coupon do
    name "Percentage!"
    code "MMM678"
    minimum_purchase_amount 2.33
    value 12.00
    start_date Date.yesterday
    end_date Date.tomorrow
  end
end
