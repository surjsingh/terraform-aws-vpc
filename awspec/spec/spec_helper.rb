require 'awspec'
require 'allure-rspec'

Awsecrets.load(secrets_path: File.expand_path('secrets.yml', File.dirname(__FILE__)))

RSpec.configure do |c|
    c.include AllureRSpec::Adaptor
end