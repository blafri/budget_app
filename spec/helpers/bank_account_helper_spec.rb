require 'rails_helper'

describe BankAccountHelper do
  context '#account_to_json' do
    it 'serializes the account object' do
      account = create(:bank_account, balance: 10)
      output = "{\"bank_account\":{\"id\":#{account.id},\"user_id\":"\
               "#{account.user_id},\"name\":\"#{account.name}\",\"balance\":\""\
               "#{account.balance}\",\"active\":#{account.active},"\
               "\"formated_balance\":\"$10.00\"}}"
      expect(helper.account_to_json(account)).to eq(output)
    end
  end
end
