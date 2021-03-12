module Uktt
  class GeographicalArea < Base
    GEOGRAPHICAL_AREAS = 'geographical_areas'.freeze

    def retrieve
      fetch "#{GEOGRAPHICAL_AREAS}"
    end
  end
end
