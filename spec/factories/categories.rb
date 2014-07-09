# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "my-category#{n}"}
    
    factory :eyeglasses_category do
      name "Eyeglasses"
    end
  end
end
