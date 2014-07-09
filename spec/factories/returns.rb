# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :return do
    order
    reason "Lorem"
    status Return::PROCESSING
    amount 22.33
    admin_comment "Ipsum"
    return_items { |r| [r.association(:return_item)] }
  end
end
