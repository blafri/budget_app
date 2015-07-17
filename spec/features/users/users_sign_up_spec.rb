require 'rails_helper'

feature 'Users sign up' do
  let(:email) { 'test@example.com' }
  let(:password) { 'password' }

  before do
    visit new_user_registration_path
  end

  scenario 'is successful with valid info' do
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_button 'Sign Up'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('A message with a confirmation link has been sent to your email address')

    # Ensure that an email was sent and that the confirmation link is valid
    expect(ActionMailer::Base.deliveries.count).to eq(1)
    expect(ActionMailer::Base.deliveries[0].to.include?(email)).to eq(true)
  end

  scenario 'fails if email is blank' do
    fill_in 'user_password', with: password
    click_button 'Sign Up'
    expect(page).to have_content('There was an error signing up!')
    expect(page).to have_content('Email can\'t be blank')
  end

  scenario 'fails if email is invalid' do
    fill_in 'user_email', with: 'hjsh@hsjsh'
    fill_in 'user_password', with: password
    click_button 'Sign Up'

    expect(page).to have_content('There was an error signing up!')
    expect(page).to have_content('Email is invalid')
  end
end