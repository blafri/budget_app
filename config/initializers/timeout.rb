# Rack timeout was causing errors running javascript tests from capybara so I
# disabled in test enviroment
Rack::Timeout.timeout = (Rails.env.test? ? 0 : 20)
