require 'faraday'
require 'faraday/follow_redirects'
require 'faraday/net_http_persistent'
require 'faraday/retry'

module Uktt
  class Http
    DEFAULT_BACKEND_SERVICE = 'uk'.freeze
    DEFAULT_PARSED_FORMAT = 'jsonapi'.freeze
    DEFAULT_RETRY_OPTIONS = {
      max: 2,
      interval: 2.0,
      interval_randomness: 0.5,
      backoff_factor: 2,
    }.freeze
    DEFAULT_VERSION = 'v2'.freeze
    DEFAULT_PUBLIC_MODE = false

    def initialize(connection, options)
      @connection = connection
      @options = options
    end

    def retrieve(resource, query_config = {})
      resource = File.join(host, 'api', version, resource)
      response = do_fetch(resource, query_config)

      Parser.new(response.body, format).parse
    end

    class << self
      def build(host, version, format, retry_options = nil)
        connection = Faraday.new(url: host) do |faraday|
          faraday.use Faraday::Response::RaiseError
          faraday.use Faraday::FollowRedirects::Middleware
          faraday.response :logger if ENV['DEBUG_REQUESTS']
          faraday.request :basic_auth, basic_username, basic_password if basic_auth?
          faraday.request :retry, retry_options || DEFAULT_RETRY_OPTIONS
          faraday.adapter :net_http_persistent
        end

        options = { host:, format:, version: }

        new(connection, options)
      end

      def basic_auth?
        ENV['BASIC_AUTH'] == 'true'
      end

      def basic_username
        ENV['BASIC_USERNAME']
      end

      def basic_password
        ENV['BASIC_PASSWORD']
      end
    end

    private

    def do_fetch(resource, query_config)
      @connection.get(resource, query_config, headers)
    end

    def headers
      {
        'Accept' => "application/vnd.uktt.#{version}",
        'Content-Type' => 'application/json',
      }
    end

    def host
      @options[:host]
    end

    def service
      @options.fetch(:service, DEFAULT_BACKEND_SERVICE)
    end

    def format
      @options.fetch(:format, DEFAULT_PARSED_FORMAT)
    end

    def version
      @options.fetch(:version, DEFAULT_VERSION)
    end
  end
end
