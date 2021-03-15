RSpec.describe Uktt::Quota do
  subject(:quota) { described_class.new(http) }

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

  describe '#search' do
    let(:params) do
      {
        goods_nomenclature_item_id: '0805102200',
        year: '2018',
        geographical_area_id: 'EG',
        order_number: '091784',
        status: 'not_blocked',
      }
    end

    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'performs a search' do
        response = quota.search(params)

        expect(response.data.first.attributes.quota_order_number_id).to eq(params[:order_number])
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it 'performs a search' do
        response = JSON.parse(quota.search(params), symbolize_names: true)

        expect(response[:data].first[:attributes][:quota_order_number_id]).to eq(params[:order_number])
      end
    end
  end
end
