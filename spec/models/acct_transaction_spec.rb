require 'rails_helper'

RSpec.describe AcctTransaction, type: :model do
  context 'validations' do
    it { should belong_to(:bank_account) }
    it { should validate_presence_of(:bank_account) }
    it { should validate_presence_of(:trans_type) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:description) }
    it { should validate_numericality_of(:amount) }

    it do
      should validate_inclusion_of(:trans_type).
        in_array(%w(debit credit))
    end

    it 'should ensure amount is greater than 0' do
      trans = AcctTransaction.new(amount: -1)
      trans.valid?
      expect(trans.errors[:amount][0]).to eq('must be greater than 0')
    end
  end

  context '.for_accounts' do
    let(:acct1) { create(:bank_account) }
    let(:acct2) { create(:bank_account) }

    before do
      create(:acct_transaction, bank_account: acct1)
      create(:acct_transaction, bank_account: acct2)
      create(:acct_transaction)
    end

    it 'sends a list of transactions for the accounts given' do
      expect(AcctTransaction.for_accounts([acct1, acct2]).count).to eq(2)
    end

    it 'orders the transactions by most recently created' do
      expect(AcctTransaction.for_accounts([acct1, acct2]).first.description).
        to eq(acct2.acct_transactions[0].description)
    end
  end
end
