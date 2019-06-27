require 'eyes_selenium'
require 'logger'

module AcornsQa
  module ApplitoolsEyes
    def self.configure(api_key: ENV['APPLITOOLS_API_KEY'], active: false)
      @is_active = active
      return unless eyes
      eyes.api_key = api_key
    end

    def self.active?
      @is_active == true
    end

    def self.open(app_name: 'Acorns App', test_name:, driver:)
      eyes&.open(
        app_name: app_name,
        test_name: test_name,
        driver: driver
      )
    end

    def self.abort_if_not_closed
      eyes&.abort_if_not_closed
    end

    def self.close
      eyes&.close
    end

    def self.check_window(page_name)
      return unless eyes
      eyes.check_window page_name
    end

    def self.handler
      eyes.log_handler = Logger.new(STDOUT)
    end

    private
    def self.eyes
      return unless ApplitoolsEyes.active?
      @eyes ||= Applitools::Selenium::Eyes.new
    end
  end
end
