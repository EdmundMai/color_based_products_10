# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :state do
    long_name "MyString"
    sequence(:short_name) { |n| "SN#{n}" }
    
    factory :new_york_state do
      short_name "NY"
    end
  end
end
