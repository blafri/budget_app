require 'rails_helper'

RSpec.describe BudgetApp::Transaction do
  let(:account) { create(:bank_account, balance: 10.89) }

  context '#create' do
    it 'saves the transaction' do
      trans = build(:acct_tran, bank_account: account)
      BudgetApp::Transaction.new(trans).create
      expect(AcctTran.count).to eq(1)
    end

    it 'returns false when there is a problem saving the data' do
      trans = build(:acct_tran, bank_account: account, trans_amount: -2)
      expect(BudgetApp::Transaction.new(trans).create).to eq(false)
    end

    it 'does not save transaction when there is an error' do
      trans = build(:acct_tran, bank_account: account, trans_amount: -2)
      BudgetApp::Transaction.new(trans).create
      expect(AcctTran.count).to eq(0)
    end

    it 'does not update account balance when there is an error' do
      trans = build(:acct_tran, bank_account: account, trans_amount: -2)
      BudgetApp::Transaction.new(trans).create
      expect(BankAccount.first.balance).to eq(BigDecimal('10.89'))
    end

    context 'debits' do
      it 'updates the account balance accordingly' do
        trans = build(:acct_tran, bank_account: account, trans_amount: 5.23)
        BudgetApp::Transaction.new(trans).create
        expect(BankAccount.first.balance).to eq(BigDecimal('5.66'))
      end
    end

    context 'credits' do
      it 'updates the account balance accordingly' do
        trans = build(:acct_tran_income, bank_account: account, trans_amount: 5.23)
        BudgetApp::Transaction.new(trans).create
        expect(BankAccount.first.balance).to eq(BigDecimal('16.12'))
      end
    end
  end

  context '#update' do
    context 'credit transaction' do
      before do
        BudgetApp::Transaction.new(build(:acct_tran_income, bank_account: account, trans_amount: 10)).create
        trans = AcctTran.first
        trans.assign_attributes(trans_amount: 5)
        BudgetApp::Transaction.new(trans).update
      end

      it 'updates the transaction' do
        expect(AcctTran.first.trans_amount).to eq(BigDecimal('5'))
      end

      it 'updates the account balance accordingly' do
        expect(BankAccount.first.balance).to eq(BigDecimal('15.89'))
      end
    end

    context 'debit transaction' do
      before do
        BudgetApp::Transaction.new(build(:acct_tran, bank_account: account, trans_amount: 10)).create
        trans = AcctTran.first
        trans.assign_attributes(trans_amount: 5)
        BudgetApp::Transaction.new(trans).update
      end

      it 'updates the transaction' do
        expect(AcctTran.first.trans_amount).to eq(BigDecimal('5'))
      end

      it 'updates the account balance accordingly' do
        expect(BankAccount.first.balance).to eq(BigDecimal('5.89'))
      end
    end

    it 'balance is not updated if transaction amount did not change' do
      BudgetApp::Transaction.new(build(:acct_tran, bank_account: account, trans_amount: 10)).create
      trans = AcctTran.first
      trans.assign_attributes(description: 'new description')
      BudgetApp::Transaction.new(trans).update
      expect(BankAccount.first.balance).to eq(BigDecimal('0.89'))
    end
  end

  context '#destroy' do
    context 'credit transaction' do
      before do
        BudgetApp::Transaction.new(build(:acct_tran_income, bank_account: account, trans_amount: 10)).create
        BudgetApp::Transaction.new(AcctTran.first).destroy
      end

      it 'deletes the transaction' do
        expect(AcctTran.count).to eq(0)
      end

      it 'updates the balance accordingly' do
        expect(BankAccount.first.balance).to eq(BigDecimal('10.89'))
      end
    end

    context 'debit transaction' do
      before do
        BudgetApp::Transaction.new(build(:acct_tran, bank_account: account, trans_amount: 10)).create
        BudgetApp::Transaction.new(AcctTran.first).destroy
      end

      it 'deletes the transaction' do
        expect(AcctTran.count).to eq(0)
      end

      it 'updates the balance accordingly' do
        expect(BankAccount.first.balance).to eq(BigDecimal('10.89'))
      end
    end
  end
end
