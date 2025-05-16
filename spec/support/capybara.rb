# Capybara and Selenium configuration
require 'capybara/rspec'
Capybara.server = :puma, { Silent: true }
Capybara.register_driver :selenium_chrome_headless do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  # Additional browser options here
  # options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1400,1400')
  options.add_argument('--disable-extensions')
  options.add_argument('--disable-popup-blocking')
  options.add_argument('--disable-notifications')
  options.add_argument('--disable-translate')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  prefs = {
    'credentials_enable_service' => false,
    'profile.password_manager_enabled' => false
  }
  options.add_preference(:prefs, prefs)
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
# Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = :selenium_chrome_headless