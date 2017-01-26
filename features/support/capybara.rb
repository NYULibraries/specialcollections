# Configure Capybara
require 'capybara/poltergeist'

Capybara.default_max_wait_time = (ENV['MAX_WAIT'] || 30).to_i

def configure_poltergeist
  # DEFAULT: headless tests with poltergeist/PhantomJS
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      phantomjs: ENV['PHANTOMJS'],
      phantomjs_options: ['--debug=no', '--load-images=no', '--ignore-ssl-errors=yes'],#, '--ssl-protocol=any'],
      window_size: [1280, 1024],
      timeout: 300,
      debug: false
    )
  end
end

def configure_selenium(browser)
  Capybara.register_driver :selenium do |app|
    profile = Kernel.const_get("Selenium::WebDriver::#{browser.to_s.capitalize}::Profile").new
    Capybara::Selenium::Driver.new(
      app,
      browser: browser.to_sym,
      profile: profile,
    )
  end
end

if ENV['IN_BROWSER']
  configure_selenium(:firefox)
  Capybara.default_driver = :selenium
  AfterStep do
    sleep (ENV['PAUSE'] || 0).to_i
  end
else
  configure_poltergeist
  Capybara.default_driver    = :poltergeist
  Capybara.javascript_driver = :poltergeist
end

Before do
  if Capybara.default_driver == :selenium
    Capybara.current_session.driver.browser.manage.window.resize_to(1280, 1024)
  end
end
