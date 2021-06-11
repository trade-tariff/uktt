require 'net/http'
require 'uri'
require 'retriable'

module Uktt
  class Http
    DEFAULT_BACKEND_SERVICE = 'uk'.freeze
    DEFAULT_PARSED_FORMAT = 'jsonapi'.freeze
    DEFAULT_RETRIABLE_INTERVALS = [0.5, 1.0, 2.0, 2.5, 20.0].freeze
    DEFAULT_VERSION = 'v2'.freeze
    DEFAULT_PUBLIC_MODE = false

    def initialize(connection, options)
      @connection = connection
      @options = options
    end

    def retrieve(resource, query_config = {})
      resource = File.join(service, 'api', version, resource) if public?
      resource = "/#{resource}#{query_params(query_config)}"

      response = Retriable.retriable(intervals: retriable_intervals) do
        do_fetch(resource)
      end

      Parser.new(response.body, format).parse
    end

    def self.build(host, version, format, public_routes, retriable_intervals = nil)
      uri = URI(host)
      connection = Net::HTTP.new(uri.host, uri.port)
      connection.use_ssl = uri.scheme.include?('https')

      options = {
        format: format,
        retriable_intervals: retriable_intervals,
        service: uri.path,
        public: public_routes,
        version: version,
      }

      new(connection, options)
    end

    private

    def do_fetch(resource, redirect_limit = 2)
      request = Net::HTTP::Get.new(resource)
      request['Accept'] = "application/vnd.uktt.#{version}"
      request['Content-Type'] = 'application/json'

      response = @connection.request(request)

      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then do_fetch(response['location'], redirect_limit - 1)
      else
        response.error!
      end
    end

    def query_params(query_config)
      return '' if query_config.empty?

      query = query_config.map do |key, value|
        "#{key}=#{value}"
      end

      "?#{query.join('&')}"
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

    def retriable_intervals
      @options.fetch(:retriable_intervals, DEFAULT_RETRIABLE_INTERVALS)
    end

    def public?
      @options.fetch(:public, DEFAULT_PUBLIC_MODE)
    end
  end
end
