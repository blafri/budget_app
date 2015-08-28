require 'headless'

RSpec.configure do |config|
  headless = Headless.new

  config.before(:each, js: true) do
    headless.start
  end

  config.after(:each, js: true) do
    headless.stop
  end

  at_exit do
    headless.destroy
  end
end
