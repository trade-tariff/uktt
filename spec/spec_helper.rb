require "json-schema"

require_relative "../lib/uktt"

RSpec.shared_context "with http resources" do
  let(:http) { Uktt::Http.build(host, version) }
  let(:host) { "https://dev.trade-tariff.service.gov.uk" }
  let(:version) { "v2" }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.include_context "with http resources", :http

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def read_file(fixture)
  fixture_path = "spec/fixtures"
  path = File.join(fixture_path, fixture)

  File.read(path)
end

def parse_file(fixture)
  file = read_file(fixture)

  JSON.parse(file)
end
