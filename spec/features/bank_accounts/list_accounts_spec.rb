require 'rails_helper'

feature 'Bank Account listing' do
  let(:user) { create(:user) }
  let!(:account1) { create(:bank_account, user: user) }
  let!(:account2) { create(:bank_account) }

  before do
    log_user_in user
    visit bank_accounts_path
  end

  scenario 'is successful' do
    expect(page).to have_content(account1.name)
    expect(page).not_to have_content(account2.name)
  end
end
