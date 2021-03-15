RSpec.describe Uktt::Commodity, :http do
  subject(:commodity) { described_class.new(http) }

  let(:commodity_id) { '0101210000' }

  describe '#retrieve' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'retrieves one commodity' do
        response = commodity.retrieve(commodity_id)
        expect(response).to be_an_instance_of(OpenStruct)
        expect(response.data.attributes.goods_nomenclature_item_id).to eq(commodity_id)
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it 'retrieves one commodity' do
        response = JSON.parse(commodity.retrieve(commodity_id), symbolize_names: true)
        expect(response).to be_an_instance_of(Hash)
        expect(response[:data][:attributes][:goods_nomenclature_item_id]).to eq(commodity_id)
      end
    end
  end

  describe '#changes' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it "retrieves one commodity's changes" do
        response = commodity.changes(commodity_id)
        expect(response).to be_an_instance_of(OpenStruct)
        expect(response.data.first.attributes).to respond_to(:oid)
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it "retrieves one commodity's changes" do
        response = JSON.parse(commodity.changes(commodity_id), symbolize_names: true)
        expect(response).to be_an_instance_of(Hash)
        expect(response[:data].first[:attributes]).to have_key(:oid)
      end
    end
  end
end
