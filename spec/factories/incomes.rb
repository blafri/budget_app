FactoryGirl.define do
  factory :income do
    user
    budget_date Time.now.to_date
  end

end
