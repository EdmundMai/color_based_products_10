# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item do
    order_id 1
    quantity 1
    unit_price 33.33
    
    before(:create) do |line_item, evaluator|
      product = FactoryGirl.create(:complete_product)
      line_item.variant_id = product.variants.last.id
    end
  end
end
