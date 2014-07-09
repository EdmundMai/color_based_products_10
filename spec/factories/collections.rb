# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :collection do
    name "MyString"
    short_description "MyText"
    long_description "MyText"
    active false
    
    factory :collection_with_a_product do
      after(:create) do |collection, evaluator|
        collection.products << FactoryGirl.create(:product)
      end
    end
    
    factory :collection_with_a_complete_product do
      after(:create) do |collection, evaluator|
        collection.products << FactoryGirl.create(:complete_product)
      end
    end
  end
end
