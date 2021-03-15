module Uktt
  class Section < Base
    RESOURCE_PATH = 'sections'.freeze

    def retrieve(section_id)
      fetch "#{RESOURCE_PATH}/#{section_id}.json"
    end

    def retrieve_all
      fetch "#{RESOURCE_PATH}.json"
    end

    def note(section_id)
      fetch "#{RESOURCE_PATH}/#{section_id}/section_note.json"
    end

    def goods_nomenclatures(section_id)
      fetch "goods_nomenclatures/section/#{section_id}.json"
    end
  end
end
