RSpec.describe Uktt::Heading, :http do
  subject(:heading) { described_class.new(http) }

  let(:heading_id) { '0101' }

  describe '#retrieve' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'retrieves one heading' do
        response = heading.retrieve(heading_id)
        expect(response).to be_an_instance_of(OpenStruct)
        expect(response.data.attributes.goods_nomenclature_item_id).to eq("#{heading_id}000000")
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it 'retrieves one heading' do
        response = JSON.parse(heading.retrieve(heading_id), symbolize_names: true)
        expect(response).to be_an_instance_of(Hash)
        expect(response[:data][:attributes][:goods_nomenclature_item_id]).to eq("#{heading_id}000000")
      end
    end
  end

  describe '#changes' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'retrieves one heading\'s changes' do
        response = heading.changes(heading_id)
        expect(response).to be_an_instance_of(OpenStruct)
        expect(response.data.first.attributes).to respond_to(:oid)
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it "retrieves one heading's changes as JSON" do
        response = JSON.parse(heading.changes(heading_id), symbolize_names: true)
        expect(response).to be_an_instance_of(Hash)
        expect(response[:data].first[:attributes]).to have_key(:oid)
      end
    end
  end

  describe '#goods_nomenclatures' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'retrieves goods nomenclatures for a heading' do
        response = heading.goods_nomenclatures(heading_id)

        expect(response.data).to be_an_instance_of(Array)
        expect(response.data.first).to be_an_instance_of(OpenStruct)
        expect(response.data.first.attributes).to respond_to(:goods_nomenclature_item_id)
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it 'retrieves goods nomenclatures for a heading' do
        response = JSON.parse(heading.goods_nomenclatures(heading_id), symbolize_names: true)

        expect(response).to be_an_instance_of(Hash)
        expect(response[:data].first[:attributes][:goods_nomenclature_item_id]).to eq("#{heading_id}000000")
      end
    end
  end
end
