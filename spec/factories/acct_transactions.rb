FactoryGirl.define do
  factory :acct_transaction do
    bank_account
    trans_type "debit"
    amount "6.62"
    sequence(:description) { |n| "transaction#{n}" }
  end

end
