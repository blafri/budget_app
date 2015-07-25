require 'rails_helper'

feature 'Edit bank account' do
  let(:user) { create(:user) }
  let!(:account) { create(:bank_account, user: user) }

  before do
    log_user_in(user)
    visit root_path
  end

  scenario 'is successful', js: true do
    within("#bank_account_#{account.id}") do
      click_button 'Edit'
    end

    fill_in 'bank_account_name', with: 'change name'
    within('#modal-buttons') { click_button 'Edit Account' }

    expect(page).to have_content('Account updated successfully.')
    expect(BankAccount.first.name).to eq('change name')
  end

  scenario 'fails with a duplicate name', js: true do
    create(:bank_account, user: user, name: 'duplicate')
    within("#bank_account_#{account.id}") do
      click_button 'Edit'
    end

    fill_in 'bank_account_name', with: 'duplicate'
    within('#modal-buttons') { click_button 'Edit Account' }
    expect(page).to have_content('Name already exists')
  end
end