require 'uktt/export_chapter_pdf'
require 'uktt/export_cover_pdf'

module Uktt
  # An object for producing PDF files of individual chapters in the Tariff
  class Pdf
    attr_accessor :chapter_id

    def initialize(opts = {})
      @chapter_id = opts[:chapter_id] || nil
      @filepath = opts[:filepath] || "#{Dir.pwd}/#{@chapter_id || 'cover'}.pdf"
      @currency = opts[:currency] || Uktt::PARENT_CURRENCY
      Uktt.configure(opts)
      @config = Uktt.config
    end

    def make_chapter
      pdf = ExportChapterPdf.new(@config.merge(chapter_id: @chapter_id))
      pdf.save_as(@filepath)
      @filepath
    end

    def make_cover
      pdf = ExportCoverPdf.new
      pdf.save_as(@filepath)
      @filepath
    end
  end
end
