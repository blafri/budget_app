require 'rails_helper'

feature 'Create bank account' do
  let(:user) { create(:user) }

  before do
    log_user_in(user)
    visit root_path
  end

  scenario 'is successful', js: true do
    find("#create-account-btn").click
    fill_in 'bank_account_name', with: 'test account'
    fill_in 'bank_account_balance', with: '100'
    within('#modal-buttons') { click_button 'Create Account' }

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Account created successfully.')
    expect(page).to have_content('test account')
    expect(BankAccount.first.name).to eq('test account')
  end

  scenario 'fails when no name given', js: true do
    find("#create-account-btn").click
    fill_in 'bank_account_balance', with: '100'
    within('#modal-buttons') { click_button 'Create Account' }

    expect(page).to have_content('Name can\'t be blank')
  end

  scenario 'fails when duplicate name is given', js: true do
    create(:bank_account, user: user, name: 'test account')
    find("#create-account-btn").click
    fill_in 'bank_account_name', with: 'test account'
    fill_in 'bank_account_balance', with: '100'
    within('#modal-buttons') { click_button 'Create Account' }

    expect(page).to have_content('Name already exists')
  end

  scenario 'fails when no balance is given', js: true do
    find("#create-account-btn").click
    fill_in 'bank_account_name', with: 'test account'
    within('#modal-buttons') { click_button 'Create Account' }

    expect(page).to have_content('Balance can\'t be blank')
  end
end
