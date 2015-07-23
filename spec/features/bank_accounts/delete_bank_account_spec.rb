require 'rails_helper'

feature 'Delete bank account' do
  let(:user) { create(:user) }
  let!(:account) { create(:bank_account, user: user) }

  before do
    log_user_in(user)
    visit root_path
  end
  scenario 'delete account successfully', js: true do
    within("#bank_account_#{account.id}") do
      click_link 'Delete'
    end

    expect(page).to have_content('Bank account deleted successfully.')
    expect(BankAccount.count).to eq(0)
  end
end