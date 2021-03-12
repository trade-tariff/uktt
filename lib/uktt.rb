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

require 'yaml'
require 'psych'

module Uktt
  API_HOST_PROD      = 'https://www.trade-tariff.service.gov.uk'.freeze
  API_HOST_LOCAL     = 'https://dev.trade-tariff.service.gov.uk'.freeze
  API_VERSION        = 'v1'.freeze
  PARENT_CURRENCY    = 'EUR'.freeze

  class Error < StandardError; end

  # Configuration defaults
  @config = {
    host: Uktt::Http.api_host,
    version: Uktt::Http.spec_version,
    debug: false,
    format: 'ostruct',
    currency: PARENT_CURRENCY,
    query: {},
  }

  @valid_config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each { |k, v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym }
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML.load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, 'YAML configuration file contains invalid syntax. Using defaults.'); return
    end

    configure(config)
  end

  def self.config
    @config
  end
end
