module Uktt
  class Section < Base
    RESOURCE_PATH = 'sections'.freeze

    attr_accessor :section_id

    def initialize(opts = {})
      @section_id = opts[:section_id] || nil
      Uktt.configure(opts.transform_keys(&:to_sym))
      @config = Uktt.config
    end

    def retrieve
      return '@section_id cannot be nil' if @section_id.nil?

      fetch "#{RESOURCE_PATH}/#{@section_id}.json"
    end

    def retrieve_all
      fetch "#{RESOURCE_PATH}.json"
    end

    def goods_nomenclatures
      return '@section_id cannot be nil' if @section_id.nil?

      fetch "goods_nomenclatures/section/#{@section_id}.json"
    end

    def note
      return '@section_id cannot be nil' if @section_id.nil?

      fetch "#{RESOURCE_PATH}/#{@section_id}/section_note.json"
    end
  end
end
