require 'rails_helper'

describe AcctTransactionPolicy do
  let(:user) { create(:user) }
  let(:user_account) { create(:bank_account, user: user) }
  let(:user_trans) { create(:acct_transaction, bank_account: user_account) }

  subject { described_class }

  permissions :new? do
    it 'allows you to see form to create a new transaction' do
      expect(subject).to permit(user, AcctTransaction.new)
    end
  end

  permissions :create? do
    it 'allows you to create a transaction for yourself' do
      expect(subject).to permit(user, build(:acct_transaction, bank_account: user_account))
    end

    it 'does not allow you to create a transaction for someone else' do
      expect(subject).not_to permit(user, build(:acct_transaction))
    end
  end

  permissions :edit? do
    it 'allows you to see edit form for a transaction you created' do
      expect(subject).to permit(user, user_trans)
    end

    it 'does not allow you to edit someone elses transaction' do
      expect(subject).not_to permit(user, create(:acct_transaction))
    end
  end

  permissions :update? do
    it 'allows you to update your transaction' do
      expect(subject).to permit(user, user_trans)
    end

    it 'does not allow you to update someone elses transaction' do
      expect(subject).not_to permit(user, create(:acct_transaction))
    end
  end

  permissions :destroy? do
    it 'allows you to delete your transaction' do
      expect(subject).to permit(user, user_trans)
    end

    it 'does not allow you to delete someone elses transaction' do
      expect(subject).not_to permit(user, create(:acct_transaction))
    end
  end
end
