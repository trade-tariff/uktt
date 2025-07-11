require "faraday"
require "faraday/follow_redirects"
require "faraday/net_http_persistent"
require "faraday/retry"

module Uktt
  class Http
    ACCEPT = 'application/vnd.hmrc.2.0+json'.freeze
    DEFAULT_RETRY_OPTIONS = {
      max: 2,
      interval: 2.0,
      interval_randomness: 0.5,
      backoff_factor: 2,
    }.freeze

    def initialize(connection, options)
      @connection = connection
      @options = options
    end

    def retrieve(resource, query_config = {})
      resource = File.join(host, resource)
      response = do_fetch(resource, query_config)

      JsonApiParser.new(response.body).parse
    end

    class << self
      def build(host, retry_options = nil)
        connection = Faraday.new(url: host) do |faraday|
          faraday.use Faraday::Response::RaiseError
          faraday.use Faraday::FollowRedirects::Middleware
          faraday.response :logger if ENV["DEBUG_REQUESTS"]
          faraday.request :basic_auth, basic_username, basic_password if basic_auth?
          faraday.request :retry, retry_options || DEFAULT_RETRY_OPTIONS
          faraday.adapter :net_http_persistent
          faraday.headers["Accept"] = ACCEPT
        end

        options = { host: }

        new(connection, options)
      end

      def basic_auth?
        ENV["BASIC_AUTH"] == "true"
      end

      def basic_username
        ENV["BASIC_USERNAME"]
      end

      def basic_password
        ENV["BASIC_PASSWORD"]
      end
    end

  private

    def do_fetch(resource, query_config)
      @connection.get(resource, query_config, headers)
    end

    def headers
      { "Content-Type" => "application/json" }
    end

    def host
      @options[:host]
    end
  end
end
