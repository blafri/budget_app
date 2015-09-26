FactoryGirl.define do
  factory :acct_tran do
    bank_account
    trans_type "debit"
    trans_amount "-10.50"
    trans_date Time.now

    factory :acct_tran_credit do
      trans_type "credit"
      trans_amount "10.50"
    end
  end

end
