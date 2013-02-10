require "logs_tf"
require "pry-nav"
require "vcr"

LogsTF::API_KEY = 'fake_api_key'

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr"
  c.hook_into :faraday
  c.configure_rspec_metadata!
end
