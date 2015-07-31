require 'rails_helper'

feature 'Delete bank account' do
  let(:user) { create(:user) }
  let!(:account) { create(:bank_account, user: user) }

  before do
    log_user_in(user)
    visit root_path
    click_button 'Edit'
  end

  scenario 'delete account successfully', js: true do
    within('#modal-buttons') { click_link 'Delete' }

    expect(page).to have_content('Bank account deleted successfully.')
    expect(BankAccount.count).to eq(0)
  end

  scenario 'shows message when account cannot be deleted', js: true do
    allow_any_instance_of(BankAccount).to receive(:destroy).and_return(false)
    within('#modal-buttons') { click_link 'Delete' }

    expect(page).to have_content('here was a problem deleting the bank account. Please try again later.')
  end
end