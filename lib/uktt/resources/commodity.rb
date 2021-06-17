module Uktt
  class Commodity < Base
    RESOURCE_PATH = 'commodities'.freeze

    def changes(commodity_id)
      fetch "#{RESOURCE_PATH}/#{commodity_id}/changes.json"
    end
  end
end
