# Capybara and Selenium configuration
require 'capybara/rspec'
Capybara.server = :puma, { Silent: true }
Capybara.register_driver :selenium_chrome_headless do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  # Additional browser options here
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
# Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = :selenium_chrome_headless