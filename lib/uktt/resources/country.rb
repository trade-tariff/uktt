module Uktt
  class Country < Base
    RESOURCE_PATH = 'geographical_areas'.freeze

    def retrieve_all(query_config = {})
      fetch "#{RESOURCE_PATH}/countries.json", query_config
    end
  end
end
