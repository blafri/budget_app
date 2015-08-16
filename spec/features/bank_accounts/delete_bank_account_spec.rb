require 'rails_helper'

feature 'Delete bank account' do
  let(:user) { create(:user) }
  let!(:account) { create(:bank_account, user: user) }

  before do
    log_user_in(user)
    visit bank_accounts_path
  end

  scenario 'is successful' do
    click_link "del-account-#{account.id}"
    expect(page).to have_content('Bank account was successfully deleted')
    expect(page).not_to have_content(account.name)
  end
end
