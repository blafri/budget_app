FactoryGirl.define do
  factory :income do
    user
    budget_month Time.now.strftime('%Y%m').to_i
    association :acct_tran, factory: :acct_tran_credit
  end

end
