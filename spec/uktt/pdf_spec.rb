RSpec.describe Uktt::Pdf do
  let(:http) do
    Uktt::Http.new(
      host,
      version,
      debug,
      conn,
      format,
    )
  end

  let(:host) { 'https://dev.trade-tariff.service.gov.uk' }
  let(:version) { 'v2' }
  let(:debug) { false }
  let(:conn) { nil }
  let(:format) { 'jsonapi' }

  describe '#make_chapter' do
    let(:chapter_id) { 'test' }

    context 'when specifying a filepath' do
      subject(:pdf) { described_class.new(http) }

      it "produces a PDF and saves it in '#{Dir.pwd}'" do
        filepath = pdf.make_chapter(chapter_id)

        expect(filepath).to eq("#{Dir.pwd}/test.pdf")
        expect(File.read(filepath)[0, 4]).to eq('%PDF')

        File.delete(filepath) if File.exist?(filepath)
      end
    end

    context 'when not specifying a filepath' do
      subject(:pdf) { described_class.new(http, '/tmp/test.pdf') }

      it 'produces a PDF and saves it at a user-specified filepath' do
        user_filepath = pdf.make_chapter(chapter_id)

        expect(user_filepath).to eq('/tmp/test.pdf')
        expect(File.read(user_filepath)[0, 4]).to eq('%PDF')

        File.delete(user_filepath) if File.exist?(user_filepath)
      end
    end
  end
end
