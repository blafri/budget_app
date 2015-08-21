FactoryGirl.define do
  factory :acct_tran do
    bank_account
    association :transactable, factory: :bucket
    transactable_type "Bucket"
    trans_type "debit"
    trans_amount "9.99"
    description "MyText"
    trans_date Time.now.to_date

    factory :acct_tran_income do
      association :transactable, factory: :income
      transactable_type "Income"
      trans_type "credit"
    end
  end

end
