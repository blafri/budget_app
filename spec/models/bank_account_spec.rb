require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  context 'validations' do
    it { should belong_to(:user) }
    it { should have_many(:acct_transactions) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:balance) }
    it { should validate_numericality_of(:balance) }
  end

  context '#update_balance_by!' do
    let(:account) { create(:bank_account, balance: 10.63) }

    it 'updates the accounts balance' do
      account.update_balance_by! BigDecimal('-8.34')
      expect(BankAccount.first.balance).to eq(BigDecimal('2.29'))
    end
  end
end
