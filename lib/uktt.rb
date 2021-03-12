require 'uktt/version'
require 'uktt/base'
require 'uktt/chapter'
require 'uktt/commodity'
require 'uktt/country'
require 'uktt/exchange_rate'
require 'uktt/geographical_area'
require 'uktt/heading'
require 'uktt/http'
require 'uktt/monetary_exchange_rate'
require 'uktt/parser'
require 'uktt/pdf'
require 'uktt/quota'
require 'uktt/section'

module Uktt
  API_HOST_PROD           = 'https://www.trade-tariff.service.gov.uk'.freeze
  API_HOST_LOCAL          = 'https://dev.trade-tariff.service.gov.uk'.freeze
  API_VERSION             = 'v2'.freeze
  DEFAULT_PARENT_CURRENCY = 'EUR'.freeze
end
