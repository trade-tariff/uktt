RSpec.describe Uktt::Commodity do
  subject(:commodity) { described_class.new(http) }

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

  describe '#find' do
    let(:format) { 'ostruct' }

    before do
      commodity.retrieve(commodity_id)
    end

    context 'when finding by id' do
      let(:type_or_id) { '20097964-duty_expression' }
      let(:expected_id) { '20097964-duty_expression' }

      it 'returns the object' do
        result = commodity.find(type_or_id)

        expect(result.id).to eq(expected_id)
      end
    end

    context 'when finding by type' do
      let(:type_or_id) { 'duty_expression' }
      let(:expected_id) { '20097964-duty_expression' }

      it 'returns the object' do
        result = commodity.find(type_or_id)

        expect(result.id).to eq(expected_id)
      end
    end
  end
end
