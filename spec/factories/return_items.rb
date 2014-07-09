# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :return_item do
    return_id 1
    quantity 1
    line_item
  end
end
