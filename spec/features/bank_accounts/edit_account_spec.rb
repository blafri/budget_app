require 'rails_helper'

feature 'Edit account' do
  let(:user) { create(:user) }
  let!(:account) { create(:bank_account, user: user) }

  before do
    log_user_in(user)
    visit bank_account_path(account)
  end

  scenario 'is successful', js: true do
    click_button "Edit Account"
    fill_in 'edit-account-name', with: 'new name'
    click_button 'Update Account'

    expect(page).to have_content('new name')
    click_link "Bank Accounts"
    expect(page).to have_css("nav a", text: 'new name')
    expect(BankAccount.first.name).to eq('new name')
  end
end
