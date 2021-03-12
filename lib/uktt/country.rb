module Uktt
  class Country < Base
    GEOGRAPHICAL_AREAS = 'geographical_areas'.freeze

    def retrieve
      fetch "#{GEOGRAPHICAL_AREAS}/countries"
    end
  end
end
