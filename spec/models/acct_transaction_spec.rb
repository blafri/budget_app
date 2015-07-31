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

  context '#trans_amount' do
    it 'returns correct amount for debit' do
      trans = create(:acct_transaction, amount: 10, trans_type: 'debit')
      expect(trans.trans_amount).to eq(BigDecimal.new(-10))
    end

    it 'returns correct amount for credit' do
      trans = create(:acct_transaction, amount: 10, trans_type: 'credit')
      expect(trans.trans_amount).to eq(BigDecimal.new(10))
    end
  end

  context '#save_and_update_account' do
    let(:account) { create(:bank_account, balance: 10.89) }

    context 'new record' do
      context 'debit transaction' do
        let(:trans) { build(:acct_transaction, bank_account: account, amount: 2.34) }

        it 'saves transaction' do
          trans.save_and_update_account
          expect(AcctTransaction.first.amount).to eq(BigDecimal('2.34'))
        end

        it 'updates account balance' do
          trans.save_and_update_account
          expect(BankAccount.first.balance).to eq(BigDecimal('8.55'))
        end

        it 'returns true on success' do
          expect(trans.save_and_update_account.class.name).to eq('TrueClass')
        end
      end

      context 'credit transaction' do
        let(:trans) { build(:acct_transaction, trans_type: 'credit', bank_account: account, amount: 2.74) }

        it 'saves transaction' do
          trans.save_and_update_account
          expect(AcctTransaction.first.amount).to eq(BigDecimal('2.74'))
        end

        it 'updates account balance' do
          trans.save_and_update_account
          expect(BankAccount.first.balance).to eq(BigDecimal('13.63'))
        end

        it 'returns true on success'do
          expect(trans.save_and_update_account.class.name).to eq('TrueClass')
        end
      end
    end

    context 'update existing record' do
      context 'debit transaction' do
        let(:trans) { build(:acct_transaction, bank_account: account, amount: 2.34) }

        before do
          trans.save_and_update_account
        end

        it 'updates account balance successfully' do
          trans = AcctTransaction.first
          trans.amount = 1.33
          trans.save_and_update_account
          expect(BankAccount.first.balance).to eq(BigDecimal('9.56'))
        end
      end

      context 'credit transaction' do
        let(:trans) { build(:acct_transaction, trans_type: 'credit', bank_account: account, amount: 2.74) }

        before do
          trans.save_and_update_account
        end

        it 'updates account balance successfully' do
          trans = AcctTransaction.first
          trans.amount = 5.34
          trans.save_and_update_account
          expect(BankAccount.first.balance).to eq(BigDecimal('16.23'))
        end
      end
    end

    context 'on error' do
      context 'balance is not updated' do
        before { @trans = AcctTransaction.new(bank_account: account) }

        it 'does not update bank account' do
          @trans.save_and_update_account
          expect(BankAccount.first.balance).to eq(BigDecimal('10.89'))
        end

        it 'returns false when there is an error' do
          expect(@trans.save_and_update_account).to eq(false)
        end
      end
    end
  end

  context '#destroy_and_update_account' do
    let(:account) { create(:bank_account, balance: 10.89) }
    let(:trans) { build(:acct_transaction, amount: 6.89, bank_account: account) }

    before do
      trans.save_and_update_account
    end

    it 'destroys the transaction' do
      trans.destroy_and_update_account
      expect(AcctTransaction.count).to eq(0)
    end

    it 'updates the bank account balance' do
      trans.destroy_and_update_account
      expect(BankAccount.first.balance).to eq(10.89)
    end

    it 'returns true on success' do
      expect(trans.destroy_and_update_account).to eq(true)
    end
  end
end
