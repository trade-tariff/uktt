require 'uktt'

RSpec.describe Uktt::Http do
  subject(:client) { described_class.new(connection, service, version, format) }

  let(:connection) { double }
  let(:service) { '' }
  let(:version) { 'v2' }
  let(:format) { 'ostruct' }

  let(:response) { Net::HTTPSuccess.new(nil, body, nil) }
  let(:body) { '{}' }
  let(:parser) { double(parse: {}) }

  describe '.build' do
    let(:host) { 'http://localhost' }

    it 'builds a Uktt::Http client instance' do
      expect(described_class.build(host, version, format)).to be_a(described_class)
    end
  end

  describe '#retrieve' do
    before do
      allow(connection).to receive(:request).and_return(response)
      allow(response).to receive(:body).and_return('{}')
      allow(Uktt::Parser).to receive(:new).and_return(parser)
    end

    let(:expected_headers) { { 'Content-Type' => 'application/json' } }
    let(:expected_body) { {} }

    it 'passes the body and format to the Parser' do
      client.retrieve('commodities/1234567890')

      expect(Uktt::Parser).to have_received(:new).with('{}', 'ostruct')
    end

    context 'when the host includes xi in the path' do
      let(:host) { 'http://localhost' }
      let(:service) { '/xi' }
      let(:expected_path) { '/xi/api/v2/commodities/1234567890' }

      it 'uses the correct full path' do
        client.retrieve('commodities/1234567890')

        expect(connection).to have_received(:request) do |request|
          expect(request.path).to eq(expected_path)
          expect(request['Content-Type']).to eq('application/json')
        end
      end
    end

    context 'when the host does not include xi in the path' do
      let(:host) { 'http://localhost' }
      let(:service) { '' }
      let(:expected_path) { '/api/v2/commodities/1234567890' }

      it 'uses the correct full url' do
        client.retrieve('commodities/1234567890')

        expect(connection).to have_received(:request) do |request|
          expect(request.path).to eq(expected_path)
          expect(request['Content-Type']).to eq('application/json')
        end
      end
    end

    context 'when a query is passed request' do
      let(:query) { { 'filter[geographical_area_id]' => 'RO' } }
      let(:host) { 'http://localhost' }
      let(:expected_path) { '/api/v2/commodities/1234567890?filter[geographical_area_id]=RO' }

      it 'uses the correct full url with the query constructed' do
        client.retrieve('commodities/1234567890', query)

        expect(connection).to have_received(:request) do |request|
          expect(request.path).to eq(expected_path)
          expect(request['Content-Type']).to eq('application/json')
        end
      end
    end
  end
end
