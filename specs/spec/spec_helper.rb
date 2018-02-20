require 'awspec'
require 'allure-rspec'

Awsecrets.load(secrets_path: File.expand_path('secrets.yml', File.dirname(__FILE__)))

RSpec.configure do |c|
    c.include AllureRSpec::Adaptor
end

AllureRSpec.configure do |c|
      c.output_dir = "reports/Allure-results/" # default: gen/allure-results
      c.clean_dir = false # clean the output directory first? (default: true)
      c.logging_level = Logger::INFO # logging level (default: DEBUG)
end