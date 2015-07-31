require 'rails_helper'

feature 'Add transaction' do
  let(:user) { create(:user) }

  before do
    create(:bank_account, user: user)
    log_user_in(user)
    visit root_path
  end

  scenario 'is successuful', js: true do
    click_button 'Add Transaction'
    fill_in 'acct_transaction_amount', with: '900'
    fill_in 'acct_transaction_description', with: 'test transaction'
    within('#modal-buttons') { click_button 'Create Transaction' }

    expect(page).to have_content('Transaction created successfully.')
    expect(AcctTransaction.count).to eq(1)
    expect(AcctTransaction.first.description).to eq('test transaction')
  end

  scenario 'is unsuccessful with missing amount', js: true do
    click_button 'Add Transaction'
    fill_in 'acct_transaction_description', with: 'test transaction'
    within('#modal-buttons') { click_button 'Create Transaction' }

    expect(page).to have_content('Amount can\'t be blank')
    expect(AcctTransaction.count).to eq(0)
  end

  scenario 'is unsuccessful with missing description', js: true do
    click_button 'Add Transaction'
    fill_in 'acct_transaction_amount', with: '900'
    within('#modal-buttons') { click_button 'Create Transaction' }

    expect(page).to have_content('Description can\'t be blank')
    expect(AcctTransaction.count).to eq(0)
  end
end
