lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uktt/version'

Gem::Specification.new do |spec|
  spec.name          = 'uktt'
  spec.version       = Uktt::VERSION
  spec.authors       = ['William Fish', 'Octavian Neguletu']
  spec.email         = ['trade-tariff-support@enginegroup.com']

  spec.summary       = 'A gem to work with the UK Trade Tariff API.'
  spec.homepage      = 'https://github.com/trade-tariff/uktt'
  spec.license       = 'MIT'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = %w[lib]
  spec.required_ruby_version = ">= #{File.read('.ruby-version').chomp}"

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday-follow_redirects'
  spec.add_dependency 'faraday-net_http_persistent'
  spec.add_dependency 'faraday-retry'
  spec.add_dependency 'net-http-persistent'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'debug'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'faraday-follow_redirects'
  spec.add_development_dependency 'faraday-retry'
  spec.add_development_dependency 'json-schema'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop-govuk'
  spec.add_development_dependency 'ruby-lsp'
  spec.add_development_dependency 'ruby-lsp-rspec'
end
