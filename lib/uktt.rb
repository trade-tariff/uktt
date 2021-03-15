Dir[File.join(__dir__, 'uktt', 'resources', '*.rb')].sort.each { |file| require file }

require 'uktt/version'
require 'uktt/http'
require 'uktt/parser'

module Uktt
  API_HOST_PROD           = 'https://www.trade-tariff.service.gov.uk'.freeze
  API_HOST_LOCAL          = 'https://dev.trade-tariff.service.gov.uk'.freeze
  API_VERSION             = 'v2'.freeze
  DEFAULT_PARENT_CURRENCY = 'EUR'.freeze
end
