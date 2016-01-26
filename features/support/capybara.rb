# Configure Capybara
require 'capybara/poltergeist'

Capybara.default_max_wait_time = 30

if ENV['IN_BROWSER']
  # On demand: non-headless tests via Selenium/WebDriver
  # To run the scenarios in browser (default: Firefox), use the following command line:
  # IN_BROWSER=true bundle exec cucumber
  # or (to have a pause of 1 second between each step):
  # IN_BROWSER=true PAUSE=1 bundle exec cucumber
  Capybara.register_driver :selenium do |app|
    http_client = Selenium::WebDriver::Remote::Http::Default.new
    http_client.timeout = 300
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :http_client => http_client)
  end
  Capybara.default_driver = :selenium
  AfterStep do
    sleep (ENV['PAUSE'] || 0).to_i
  end
else
  # DEFAULT: headless tests with poltergeist/PhantomJS
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
    app,
    phantomjs_options: ['--debug=no', '--load-images=no', '--ignore-ssl-errors=yes'],#, '--ssl-protocol=any'],
    window_size: [1280, 1024],
    timeout: 300,
    debug: false
    )
  end
  Capybara.default_driver    = :poltergeist
  Capybara.javascript_driver = :poltergeist
end

Before do
  if Capybara.default_driver == :selenium
    Capybara.current_session.driver.browser.manage.window.resize_to(1280, 1024)
  end
end
