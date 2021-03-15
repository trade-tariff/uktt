require 'faraday'
require 'faraday_middleware'

module Uktt
  # An object for handling network requests
  class Http
    def initialize(host = nil, version = nil, debug = false, conn = nil, format = 'jsonapi')
      @host = host || API_HOST_LOCAL
      @version = version || API_VERSION
      @format = format

      @conn = conn || Faraday.new(url: @host) do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.response(:logger) if debug
        faraday.adapter Faraday.default_adapter
      end
    end

    def retrieve(resource, query_config = {})
      full_url = File.join(@host, 'api', @version, resource)
      full_url = "#{full_url}#{query_params(query_config)}"
      headers  = { 'Content-Type' => 'application/json' }
      response = @conn.get(full_url, {}, headers)

      Parser.new(response.body, @format).parse
    end

    private

    def query_params(query_config)
      return '' if query_config.empty?

      query = query_config.map do |key, value|
        "#{key}=#{value}"
      end

      "?#{query.join(',')}"
    end
  end
end
