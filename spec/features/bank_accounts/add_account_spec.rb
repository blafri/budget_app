require 'rails_helper'

feature 'Add bank account' do
  let(:user) { create(:user) }

  before do
    log_user_in(user)
    visit new_bank_account_path
  end

  scenario 'is successful' do
    fill_in 'bank_account_name', with: 'test name'
    fill_in 'bank_account_balance', with: 12.78
    click_button 'Create'

    expect(page).to have_content('Bank account was successfully created.')
    expect(page).to have_content('12.78')
    expect(BankAccount.first.name).to eq('test name')
  end

  scenario 'is unsuccessful' do
    click_button 'Create'
    expect(page).to have_content('Bank account could not be created.')
    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_content('Balance must be a number')
  end
end
