module Uktt
  class GeographicalArea < Base
    def retrieve
      fetch "#{GEOGRAPHICAL_AREAS}"
    end
  end
end
