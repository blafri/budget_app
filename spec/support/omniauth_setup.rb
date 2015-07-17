OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
  provider: 'google_oauth2',
  uid: '123545',
  info: { email: 'test@test.com' }
)
