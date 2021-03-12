RSpec.describe Uktt::Chapter do
  subject(:chapter) { described_class.new(http) }

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

  let(:chapter_id) { '01' }

  describe '#retrieve' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'retrieves one chapter' do
        response = chapter.retrieve(chapter_id)

        expect(response).to be_an_instance_of(OpenStruct)
        expect(response.data.attributes.goods_nomenclature_item_id).to eq("#{chapter_id}00000000")
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it 'retrieves one chapter' do
        response = JSON.parse(chapter.retrieve(chapter_id), symbolize_names: true)

        expect(response[:data][:attributes]).to be_an_instance_of(Hash)
        expect(response[:data][:attributes][:goods_nomenclature_item_id]).to eq("#{chapter_id}00000000")
      end
    end
  end

  describe '#note' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it "retrieves one chapter's note" do
        response = chapter.note(chapter_id)

        expect(response.section_id.to_s).to eq('')
        expect(response.chapter_id).to eq(chapter_id)
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it "retrieves one chapter's note" do
        response = JSON.parse(chapter.note(chapter_id), symbolize_names: true)

        expect(response[:section_id].to_s).to eq('')
        expect(response[:chapter_id]).to eq(chapter_id)
      end
    end
  end

  describe '#changes' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'retrieves one chapter\'s changes' do
        response = chapter.changes(chapter_id)
        expect(response).to be_an_instance_of(OpenStruct)
        expect(response.data.first.attributes).to respond_to(:oid)
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it "retrieves one chapter's changes" do
        response = JSON.parse(chapter.changes(chapter_id), symbolize_names: true)
        expect(response).to be_an_instance_of(Hash)
        expect(response[:data].first[:attributes]).to have_key(:oid)
      end
    end
  end

  describe '#retrieve_all' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'retrieves all chapters as [OpenStructs]' do
        response = chapter.retrieve_all
        expect(response.data).to be_an_instance_of(Array)
        expect(response.data.length).to eq(98)
        expect(response.data.first).to be_an_instance_of(OpenStruct)
        expect(response.data.first.attributes.goods_nomenclature_item_id).to eq('0100000000')
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it 'retrieves all chapters as JSON' do
        response = JSON.parse(chapter.retrieve_all, symbolize_names: true)
        expect(response[:data]).to be_an_instance_of(Array)
        expect(response[:data].length).to eq(98)
      end
    end
  end

  describe '#goods_nomenclatures' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'retrieves goods nomenclatures for a chapter' do
        response = chapter.goods_nomenclatures(chapter_id)

        expect(response.data).to be_an_instance_of(Array)
        expect(response.data.first).to be_an_instance_of(OpenStruct)
        expect(response.data.first.attributes).to respond_to(:goods_nomenclature_item_id)
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it 'retrieves goods nomenclatures for a chapter' do
        response = JSON.parse(chapter.goods_nomenclatures(chapter_id), symbolize_names: true)

        expect(response).to be_an_instance_of(Hash)
        expect(response[:data].first[:attributes][:goods_nomenclature_item_id][0..1]).to eq(chapter_id)
      end
    end
  end
end
