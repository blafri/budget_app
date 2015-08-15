require 'rails_helper'

feature 'Add transaction' do
  let(:user) { create(:user) }
  let(:account) { create(:bank_account, user: user, balance: 10561.11) }

  before do
    account
    log_user_in(user)
    visit root_path
  end

  context 'is successful' do
    scenario 'with debit transaction', js: true do
      click_button 'Add Transaction'
      fill_in 'acct_transaction_amount', with: '900.29'
      fill_in 'acct_transaction_description', with: 'test transaction'
      within('#modal-buttons') { click_button 'Create' }

      expect(page).to have_content('Transaction created successfully.')
      expect(page).to have_css("#bank_account_#{account.id}", text: '9,660.82')
      expect(AcctTransaction.count).to eq(1)
      expect(AcctTransaction.first.description).to eq('test transaction')
    end

    scenario 'with credit transaction', js: true do
      click_button 'Add Transaction'
      select('Credit', :from => 'acct_transaction_trans_type')
      fill_in 'acct_transaction_amount', with: '900.29'
      fill_in 'acct_transaction_description', with: 'test transaction'
      within('#modal-buttons') { click_button 'Create' }

      expect(page).to have_content('Transaction created successfully.')
      expect(page).to have_css("#bank_account_#{account.id}", text: '11,461.40')
      expect(AcctTransaction.count).to eq(1)
      expect(AcctTransaction.first.description).to eq('test transaction')
    end
  end

  scenario 'is unsuccessful with missing amount', js: true do
    click_button 'Add Transaction'
    fill_in 'acct_transaction_description', with: 'test transaction'
    within('#modal-buttons') { click_button 'Create' }

    expect(page).to have_content('Amount can\'t be blank')
    expect(AcctTransaction.count).to eq(0)
  end

  scenario 'is unsuccessful with missing description', js: true do
    click_button 'Add Transaction'
    fill_in 'acct_transaction_amount', with: '900'
    within('#modal-buttons') { click_button 'Create' }

    expect(page).to have_content('Description can\'t be blank')
    expect(AcctTransaction.count).to eq(0)
  end
end
