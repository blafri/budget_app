FactoryGirl.define do
  factory :bank_account do
    user
    sequence(:name) { |n| "bank account #{n}" }
    balance 100
  end

end
