# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :color do
    sequence(:name) { |n| "my-color#{n}"; }
    image { fixture_file_upload("#{Rails.root}/spec/support/sample_img.jpg", 'image/jpg') }
  end
end
