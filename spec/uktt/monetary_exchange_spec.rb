RSpec.describe Uktt::MonetaryExchangeRate do
  subject(:monetary_exchange_rate) { described_class.new(http) }

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

  describe '#retrieve_all' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'retrieves monetary exchange rates' do
        response = monetary_exchange_rate.retrieve_all
        expect(response.data).to be_an_instance_of(Array)
        expect(response.data.first).to be_an_instance_of(OpenStruct)
        expect(response.data.first.attributes).to respond_to(:exchange_rate)
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it 'retrieves monetary exchange rates' do
        response = JSON.parse(monetary_exchange_rate.retrieve_all, symbolize_names: true)
        expect(response[:data]).to be_an_instance_of(Array)
        expect(response[:data].first).to be_an_instance_of(Hash)
        expect(response[:data].first[:attributes]).to have_key(:exchange_rate)
      end
    end
  end
end
