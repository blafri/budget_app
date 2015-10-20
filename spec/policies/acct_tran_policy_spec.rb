require 'rails_helper'

describe AcctTranPolicy do

  let(:user) { create(:user) }

  subject { described_class }

  permissions ".scope" do
    let(:user2) { create(:user) }
    let(:policy_scope) { AcctTranPolicy::Scope.new(user, AcctTran).resolve }

    before do
      user2_account = create(:bank_account, user: user2)
      create(:acct_tran, bank_account: user2_account)
    end

    it 'does not see another users transactions' do
      expect(policy_scope).to eq([])
    end

    it 'sees his own transactions' do
      user_account = create(:bank_account, user: user)
      tran = create(:acct_tran, bank_account: user_account)

      expect(policy_scope).to eq([tran])
    end
  end
end
