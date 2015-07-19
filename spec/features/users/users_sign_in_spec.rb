require 'rails_helper'

feature 'Users sign in' do
  let(:user) { create(:user) }

  before do
    visit new_user_session_path
  end
  scenario 'is successful with valid info' do
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log In'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Signed in successfully')
  end

  scenario 'is unsuccessful with invalid info' do
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'bad_password'
    click_button 'Log In'

    expect(current_path).to eq(user_session_path)
    expect(page).to have_content('Invalid email or password.')
  end

  context 'is successful using google' do
    scenario 'with no previous account' do
      click_link 'Sign in with Google'
      expect(current_path).to eq(root_path)
      expect(page).to have_content('Signed in successfully')
      expect(User.count).to eq(1)
      expect(User.first.email).to eq('test@test.com')
    end

    scenario 'with a previous account' do
      create :user_test
      click_link 'Sign in with Google'
      expect(current_path).to eq(root_path)
      expect(page).to have_content('Signed in successfully')
      expect(User.count).to eq(1)
    end
  end
end