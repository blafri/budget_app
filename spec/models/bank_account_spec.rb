require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  context 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:name) }
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:acct_trans).dependent(:destroy)}
  end

  context '#update_balance_by!' do
    let(:account) { create(:bank_account, balance: 8.67) }

    it 'is successful for positive value' do
      account.update_balance_by! BigDecimal('2.35')
      expect(account.balance).to eq(BigDecimal('11.02'))
    end

    it 'is successful for negative value' do
      account.update_balance_by! BigDecimal('-5.78')
      expect(account.balance).to eq(BigDecimal('2.89'))
    end
  end
end
