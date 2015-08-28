require 'rails_helper'

describe BankAccountPolicy do

  let(:user) { create(:user) }
  let(:my_account) { build(:bank_account, user: user) }
  let(:account) { build(:bank_account) }

  subject { described_class }

  permissions :new? do
    it 'allows a user to create a bank if he is signed in' do
      expect(subject).to permit(user, BankAccount.new)
    end
  end

  permissions :create? do
    it 'allows a user to create a bank account for himself' do
      expect(subject).to permit(user, my_account)
    end

    it 'denies access if he is not the owner' do
      expect(subject).not_to permit(user, account)
    end
  end

  permissions :update? do
    it 'allows a user to update his own bank account' do
      expect(subject).to permit(user, my_account)
    end

    it 'denies access to update someone elses account' do
      expect(subject).not_to permit(user, account)
    end
  end

  permissions :destroy? do
    it 'allows a user to delete his own bank account' do
      expect(subject).to permit(user, my_account)
    end

    it 'denies access if he is not the owner' do
      expect(subject).not_to permit(user, account)
    end
  end
end
