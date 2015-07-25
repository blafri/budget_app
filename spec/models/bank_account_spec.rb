require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  let(:account) { create(:bank_account) }

  context 'validations' do
    it { should belong_to(:user) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:balance) }

    it 'should not allow duplicate names for a single user' do
      account2 = build(:bank_account, user: account.user, name: account.name)
      expect(account2.valid?).to eq(false)
    end

    it 'should allow duplicate name for different users' do
      account2 = build(:bank_account, name: account.name)
      expect(account2.valid?).to eq(true)
    end
  end
end
