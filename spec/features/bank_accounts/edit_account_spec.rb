require 'rails_helper'

feature 'Edit account' do
  let(:user) { create(:user) }
  let!(:account) { create(:bank_account, user: user) }

  before do
    log_user_in(user)
    visit bank_account_path(account)
  end

  scenario 'is successful', js: true do
    within('#display-account-name') do
      find('.glyphicon-edit').click
    end
    fill_in 'new-acct-name', with: 'new acct name'
    click_button 'Save'

    expect(page).to have_content('new acct name')
    expect(BankAccount.first.name).to eq('new acct name')
  end
end
