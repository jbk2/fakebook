# spec/support/capybara.rb

# Capybara and Selenium configuration
require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.server = :puma, { Silent: true }

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('no-sandbox')
  options.add_argument('disable-dev-shm-usage')
  options.add_argument('window-size=1400,1400')
  
  Capybara::Selenium::Driver.new(app,
    browser: :remote,
    url: 'http://selenium:4444/wd/hub',
    capabilities: options
  )
end

Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = :selenium_chrome_headless
