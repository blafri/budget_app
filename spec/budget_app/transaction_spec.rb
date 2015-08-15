require 'rails_helper'

RSpec.describe BudgetApp::Transaction do
  let(:account) { create(:bank_account, balance: 113.37) }

  context '#create' do
    context 'debit transaction' do
      let(:trans) { trans = described_class.new(build(:acct_transaction,
                                                      bank_account: account)) }

      it 'updates account balance' do
        trans.create
        expect(BankAccount.first.balance).to eq(BigDecimal('106.75'))
      end

      it 'does not update account balance on failure' do
        allow_any_instance_of(AcctTransaction).to receive(:valid?).and_return(false)
        trans.create
        expect(BankAccount.first.balance).to eq(BigDecimal('113.37'))
      end
    end

    context 'credit transaction' do
      let(:trans) { trans = described_class.new(build(:acct_transaction,
                                                      bank_account: account,
                                                      trans_type: 'credit')) }

      it 'updates account transaction' do
        trans.create
        expect(BankAccount.first.balance).to eq(BigDecimal('119.99'))
      end
    end

    it 'returns true on success' do
      trans = described_class.new(build(:acct_transaction))
      expect(trans.create).to eq(true)
    end

    it 'returns false on failure' do
      allow_any_instance_of(AcctTransaction).to receive(:valid?).and_return(false)
      trans = described_class.new(build(:acct_transaction))
      expect(trans.create).to eq(false)
    end

    it 'saves transaction' do
      trans = described_class.new(build(:acct_transaction))
      trans.create
      expect(AcctTransaction.first.amount).to eq(trans.transaction.amount)
    end
  end

  context '#update_transaction' do
    context 'debit' do
      before do
        trans = described_class.new(build(:acct_transaction, bank_account: account))
        trans.create
        @trans = described_class.new(AcctTransaction.first)
        @trans.transaction.amount = 41.38
      end

      it 'updates transaction' do
        @trans.update
        expect(AcctTransaction.first.amount).to eq(BigDecimal('41.38'))
      end

      it 'updates bank account' do
        @trans.update
        expect(BankAccount.first.balance).to eq(BigDecimal('71.99'))
      end

      it 'returns true on success' do
        expect(@trans.update).to eq(true)
      end

      it 'returns false on failure' do
        allow_any_instance_of(AcctTransaction).to receive(:valid?).and_return(false)
        expect(@trans.update).to eq(false)
      end

      it 'does not change account balance on failure' do
        allow_any_instance_of(AcctTransaction).to receive(:valid?).and_return(false)
        @trans.update
        expect(BankAccount.first.balance).to eq(BigDecimal('106.75'))
      end
    end

    context 'credit' do
      before do
        trans = described_class.new(build(:acct_transaction,
                                          bank_account: account,
                                          trans_type: 'credit'))
        trans.create
        @trans = described_class.new(AcctTransaction.first)
        @trans.transaction.amount = 41.38
      end

      it 'updates bank account' do
        @trans.update
        expect(BankAccount.first.balance).to eq(BigDecimal('154.75'))
      end
    end
  end

  context '#destroy' do
    let(:transaction) { build(:acct_transaction, bank_account: account) }

    context 'debit transaction' do
      before do
        trans = BudgetApp::Transaction.new(transaction)
        trans.create
        @trans = BudgetApp::Transaction.new(AcctTransaction.first)
      end

      it 'deletes the transaction' do
        @trans.destroy
        expect(AcctTransaction.count).to eq(0)
      end

      it 'updates acount balance' do
        @trans.destroy
        expect(BankAccount.first.balance).to eq(BigDecimal('113.37'))
      end

      it 'returns true on success' do
        expect(@trans.destroy).to eq(true)
      end
    end

    context 'credit transaction' do
      it 'updates account balnce' do
        trans = BudgetApp::Transaction.new(build(:acct_transaction,
                                                 bank_account: account,
                                                 trans_type: 'credit'))
        trans.create
        trans = BudgetApp::Transaction.new(AcctTransaction.first)
        trans.destroy
        expect(BankAccount.first.balance).to eq(BigDecimal('113.37'))
      end
    end
  end
end
