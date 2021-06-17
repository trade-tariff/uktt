require 'uktt'

RSpec.describe Uktt::Http do
  subject(:client) { described_class.new(connection, options) }

  let(:connection) { double }
  let(:service) { '' }
  let(:version) { 'v2' }
  let(:format) { 'ostruct' }
  let(:retriable_intervals) { [] }
  let(:public_routes) { false }

  let(:response) { Net::HTTPSuccess.new(nil, body, nil) }
  let(:body) { '{}' }
  let(:parser) { double(parse: {}) }

  let(:options) do
    {
      format: format,
      retriable_intervals: retriable_intervals,
      service: service,
      version: version,
      public: public_routes,
    }
  end

  describe '.build' do
    let(:host) { 'http://localhost' }

    it 'builds a Uktt::Http client instance' do
      expect(described_class.build(host, version, format, retriable_intervals)).to be_a(described_class)
    end
  end

  describe '#retrieve' do
    before do
      allow(connection).to receive(:request).and_return(response)
      allow(response).to receive(:body).and_return('{}')
      allow(Uktt::Parser).to receive(:new).and_return(parser)
      allow(Retriable).to receive(:retriable).and_call_original
      allow(Net::HTTP::Get).to receive(:new).and_call_original
    end

    let(:expected_headers) { { 'Content-Type' => 'application/json' } }
    let(:expected_body) { {} }

    it 'initializes a request object with the correct resource' do
      client.retrieve('commodities/1234567890')

      expect(Net::HTTP::Get).to have_received(:new).with('/commodities/1234567890')
    end

    it 'passes the body and format to the Parser' do
      client.retrieve('commodities/1234567890')

      expect(Uktt::Parser).to have_received(:new).with('{}', 'ostruct')
    end

    it 'uses the retriable implementation to retry on failure' do
      client.retrieve('commodities/1234567890')

      expect(Retriable).to have_received(:retriable)
    end

    context 'when public routes are specified' do
      let(:public_routes) { true }

      it 'initializes a request object with the correct resource' do
        client.retrieve('commodities/1234567890')

        expect(Net::HTTP::Get).to have_received(:new).with('/api/v2/commodities/1234567890')
      end
    end

    context 'when a query is passed' do
      let(:query) { { 'filter[geographical_area_id]' => 'RO', 'as_of' => '2022-09-11' } }
      let(:host) { 'http://localhost' }
      let(:expected_path) { '/commodities/1234567890?filter[geographical_area_id]=RO&as_of=2022-09-11' }

      it 'uses the correct full url with the query constructed' do
        client.retrieve('commodities/1234567890', query)

        expect(connection).to have_received(:request) do |request|
          expect(request.path).to eq(expected_path)
          expect(request['Content-Type']).to eq('application/json')
          expect(request['Accept']).to eq('application/vnd.uktt.v2')
        end
      end
    end
  end
end
