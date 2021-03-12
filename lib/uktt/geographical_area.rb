module Uktt
  class GeographicalArea < Base
    RESOURCE_PATH = 'geographical_areas'.freeze

    def retrieve
      fetch RESOURCE_PATH
    end
  end
end
