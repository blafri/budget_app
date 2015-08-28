FactoryGirl.define do
  factory :bucket do
    user
    sequence(:name) { |n| "bucket_#{n}" }
  end

end
