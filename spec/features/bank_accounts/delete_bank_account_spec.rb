require 'rails_helper'

feature 'Delete bank account' do
  let(:user) { create(:user) }
  let!(:account) { create(:bank_account, user: user) }

  before do
    log_user_in(user)
    visit bank_account_path(account)
  end

  scenario 'is successful', js: true do
    accept_alert do
      click_link "Delete Account"
    end
    
    expect(page).to have_content('Bank account was successfully deleted')
    expect(BankAccount.count).to eq(0)
  end
end
