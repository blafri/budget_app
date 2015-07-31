require 'rails_helper'

feature 'Edit tranaction' do
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
    fill_in 'acct_transaction_amount', with: '90894'
    within('#modal-buttons') { click_button 'Update' }

    expect(page).to have_content('Transaction updated successfully.')
    expect(AcctTransaction.count).to eq(1)
    expect(AcctTransaction.first.amount).to eq(90894)
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
