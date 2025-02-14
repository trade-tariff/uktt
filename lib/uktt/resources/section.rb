module Uktt
  class Section < Base
    RESOURCE_PATH = 'sections'.freeze

    def goods_nomenclatures(section_id)
      fetch "goods_nomenclatures/section/#{section_id}.json"
    end
  end
end
