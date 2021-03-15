module Uktt
  # A Commodity object for dealing with an API resource
  class Commodity < Base
    RESOURCE_PATH = 'commodities'.freeze

    def retrieve(commodity_id)
      fetch "#{RESOURCE_PATH}/#{commodity_id}.json"
    end

    def changes(commodity_id)
      fetch "#{RESOURCE_PATH}/#{commodity_id}/changes.json"
    end

    def find(id_or_type)
      @response.included.find { |obj| obj.id == id_or_type || obj.type == id_or_type }
    end
  end
end
