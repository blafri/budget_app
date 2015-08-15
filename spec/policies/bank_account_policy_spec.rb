require 'rails_helper'

describe BankAccountPolicy do
  let(:user) { create(:user) }
  let(:user_account) { build(:bank_account, user: user) }

  subject { described_class }

  permissions :new? do
    it 'allows you to see form to create a new account' do
      expect(subject).to permit(user, BankAccount.new)
    end
  end

  permissions :create? do
    it 'allows you to create a bank account for yourself' do
      expect(subject).to permit(user, user_account)
    end

    it 'does not allow you to create bank accounts for someone else' do
      expect(subject).not_to permit(user, build(:bank_account))
    end
  end

  permissions :edit? do
    it 'allows you to see edit form for your account' do
      expect(subject).to permit(user, user_account)
    end

    it 'does not allow you to see edit form for someone elses account' do
      expect(subject).not_to permit(user, build(:bank_account))
    end
  end

  permissions :update? do
    it 'allows you to update your account' do
      expect(subject).to permit(user, user_account)
    end

    it 'does not allow you to update someone elses account' do
      expect(subject).not_to permit(user, build(:bank_account))
    end
  end

  permissions :destroy? do
    it 'allows you to delete your bank account' do
      expect(subject).to permit(user, user_account)
    end

    it 'does not allow you to update someone elses account' do
      expect(subject).not_to permit(user, build(:bank_account))
    end
  end
end
