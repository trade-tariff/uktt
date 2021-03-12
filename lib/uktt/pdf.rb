require 'uktt/export_chapter_pdf'
require 'uktt/export_cover_pdf'

module Uktt
  class Pdf
    def initialize(http, path = nil)
      @http = http
      @path = path
    end

    def make_chapter(chapter_id, currency = nil)
      @chapter_id = chapter_id
      currency ||= Uktt::DEFAULT_PARENT_CURRENCY

      pdf = ExportChapterPdf.new(
        @http,
        chapter_id: chapter_id,
        currency: currency,
      )

      pdf.save_as(chapter_path)

      chapter_path
    end

    def make_cover
      pdf = ExportCoverPdf.new

      pdf.save_as(path)

      cover_path
    end

    private

    def chapter_path
      @path ||= "#{Dir.pwd}/#{@chapter_id}.pdf"
    end

    def cover_path
      @path ||= "#{Dir.pwd}/cover.pdf"
    end
  end
end
