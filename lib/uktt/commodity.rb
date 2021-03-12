module Uktt
  # A Commodity object for dealing with an API resource
  class Commodity < Base
    RESOURCE_PATH = 'commodities'.freeze

    attr_accessor :commodity_id, :response

    def initialize(opts = {})
      @commodity_id = opts[:commodity_id] || nil
      Uktt.config.merge(opts)
      @config = Uktt.config
      @response = nil
    end

    def retrieve
      return '@commodity_id cannot be nil' if @commodity_id.nil?

      fetch "#{RESOURCE_PATH}/#{@commodity_id}.json"
    end

    def changes
      return '@commodity_id cannot be nil' if @commodity_id.nil?

      fetch "#{RESOURCE_PATH}/#{@commodity_id}/changes.json"
    end

    def find(id)
      return '@response is nil, run #retrieve first' unless @response

      response = @response.included.select do |obj|
        obj.id === id || obj.type === id
      end
      response.length == 1 ? response.first : response
    end

    def find_in(arr)
      return '@response is nil, run #retrieve first' unless @response

      response = @response.included.select do |obj|
        arr.include?(obj.id)
      end
      response.length == 1 ? response.first : response
    end
  end
end
