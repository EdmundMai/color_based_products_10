# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipping_address do
    first_name "John"
    last_name "Smith"
    street_address "123 Fake Street"
    street_address2 "68"
    city "New York"
    zip_code "10001"
    phone_number "1231231234"
    state
  end
end
