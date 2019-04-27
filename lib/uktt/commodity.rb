module Uktt
  # A Commodity object for dealing with an API resource
  class Commodity
    attr_accessor :host, :version, :return_json, :commodity_id, :debug

    def initialize(commodity_id,
                   json = false,
                   host = Uktt::Http.api_host,
                   version = Uktt::Http.spec_version,
                   debug = false)
      @host = host
      @version = version
      @commodity_id = commodity_id
      @return_json = json
      @debug = debug
    end

    def retrieve
      fetch "#{COMMODITY}/#{@commodity_id}.json"
    end

    def changes
      fetch "#{COMMODITY}/#{@commodity_id}/changes.json"
    end

    private

    def fetch(resource)
      Uktt::Http.new(@host, @version, @debug).retrieve(resource, @return_json)
    end
  end
end
