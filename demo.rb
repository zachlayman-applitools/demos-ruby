require 'eyes_selenium'
require 'selenium-webdriver'

# Initialize the eyes SDK and set your private API key.
eyes = Applitools::Selenium::Eyes.new
eyes.api_key = ENV['APPLITOOLS_API_KEY']

# Open a Chrome Browser.
driver = Selenium::WebDriver.for :chrome

begin
  # Start the test and set the browser's viewport size to 800x600.
  eyes.test(app_name: 'Hello World!', test_name: 'My first Selenium Ruby test!',
            viewport_size: { width: 800, height: 600 }, driver: driver) do

    # Navigate the browser to the "hello world!" web-site.
    driver.get 'https://applitools.com/helloworld'

    # Visual checkpoint #1.
    eyes.check_window 'Hello!'
    # eyes.set_proxy 'http://google.com'
    # Click the "Click me!".
    driver.find_element(tag_name: 'button').click

    # Visual checkpoint #2.
    eyes.check_window 'Click!'
  end
ensure
  # Close the browser.
  driver.quit

  # If the test was aborted before eyes.close was called, ends the test as aborted.
  eyes.abort_if_not_closed
end
