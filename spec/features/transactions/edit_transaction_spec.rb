require 'rails_helper'

feature 'Edit tranaction' do
  let(:user) { create(:user) }
  let(:account) { create(:bank_account, user: user, balance: 16890) }

  context 'debit transaction' do
    let(:trans) { build(:acct_transaction, bank_account: account) }

    before do
      BudgetApp::Transaction.new(trans).create
      log_user_in user
      visit root_path
      click_button 'View'
    end

    scenario 'is successful', js: true do
      fill_in 'acct_transaction_amount', with: '9894.74'
      within('#modal-buttons') { click_button 'Update' }

      expect(page).to have_content('Transaction updated successfully.')
      expect(page).to have_css("#bank_account_#{account.id}", text: '6,995.26')
      expect(AcctTransaction.count).to eq(1)
      expect(AcctTransaction.first.amount).to eq(BigDecimal('9894.74'))
    end

    scenario 'is unsuccessful if amount missing', js: true do
      fill_in 'acct_transaction_amount', with: ''
      within('#modal-buttons') { click_button 'Update' }

      expect(page).to have_content('Amount can\'t be blank')
    end

    scenario 'is unsuccessful if description missing', js: true do
      fill_in 'acct_transaction_description', with: ''
      within('#modal-buttons') { click_button 'Update' }

      expect(page).to have_content('Description can\'t be blank')
    end
  end

  context 'credit transaction' do
    let(:trans) { build(:acct_transaction, bank_account: account, trans_type: 'credit') }

    before do
      BudgetApp::Transaction.new(trans).create
      log_user_in user
      visit root_path
      click_button 'View'
    end

    scenario 'is successful', js: true do
      fill_in 'acct_transaction_amount', with: '9894.74'
      within('#modal-buttons') { click_button 'Update' }

      expect(page).to have_content('Transaction updated successfully.')
      expect(page).to have_css("#bank_account_#{account.id}", text: '26,784.74')
      expect(AcctTransaction.count).to eq(1)
      expect(AcctTransaction.first.amount).to eq(BigDecimal('9894.74'))
    end
  end
end
