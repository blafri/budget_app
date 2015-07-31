require 'rails_helper'

feature 'Delete tranaction' do
  let(:user) { create(:user) }
  let(:account) { create(:bank_account, user: user) }
  let(:trans) { create(:acct_transaction, bank_account: account) }

  before do
    trans
    log_user_in user
    visit root_path
    click_button 'View'
  end

  scenario 'is successful', js: true do
    within('#modal-buttons') { click_link 'Delete' }

    expect(page).to have_content('The transaction was deleted successfully.')
    expect(AcctTransaction.count).to eq(0)
  end

  scenario 'error msg is shown if there was a problem', js: true do
    allow_any_instance_of(AcctTransaction).to receive(:destroy).and_return(false)
    within('#modal-buttons') { click_link 'Delete' }

    expect(page).to have_content('There was a problem deleting the transaction. Please try again later.')
  end
end