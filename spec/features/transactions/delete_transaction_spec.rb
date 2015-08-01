require 'rails_helper'

feature 'Delete tranaction' do
  let(:user) { create(:user) }
  let(:account) { create(:bank_account, user: user, balance: 10678.34) }

  context 'debit transaction' do
    let(:trans) { build(:acct_transaction, bank_account: account) }

    before do
      BudgetApp::Transaction.new(trans).create_transaction
      log_user_in user
      visit root_path
      click_button 'View'
    end

    scenario 'is successful', js: true do
      within('#modal-buttons') { click_link 'Delete' }

      expect(page).to have_content('The transaction was deleted successfully.')
      expect(page).to have_css("#bank_account_#{account.id}", text: '10,678.34')
      expect(AcctTransaction.count).to eq(0)
    end

    scenario 'error msg is shown if there was a problem', js: true do
      allow_any_instance_of(AcctTransaction).to receive(:destroy).and_return(false)
      within('#modal-buttons') { click_link 'Delete' }

      expect(page).to have_content('There was a problem deleting the transaction. Please try again later.')
    end
  end

  context 'credit transaction' do
    let(:trans) { build(:acct_transaction, bank_account: account, trans_type: 'credit') }

    before do
      BudgetApp::Transaction.new(trans).create_transaction
      log_user_in user
      visit root_path
      click_button 'View'
    end

    scenario 'is successful', js: true do
      within('#modal-buttons') { click_link 'Delete' }

      expect(page).to have_content('The transaction was deleted successfully.')
      expect(page).to have_css("#bank_account_#{account.id}", text: '10,678.34')
      expect(AcctTransaction.count).to eq(0)
    end
  end
end