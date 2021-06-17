module Uktt
  class Chapter < Base
    RESOURCE_PATH = 'chapters'.freeze

    def goods_nomenclatures(chapter_id)
      fetch "goods_nomenclatures/chapter/#{chapter_id}.json"
    end

    def changes(chapter_id)
      fetch "#{RESOURCE_PATH}/#{chapter_id}/changes.json"
    end

    def note(chapter_id)
      fetch "#{RESOURCE_PATH}/#{chapter_id}/chapter_note.json"
    end
  end
end
