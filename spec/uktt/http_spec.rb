require "uktt"

RSpec.describe Uktt::Http do
  subject(:client) { described_class.new(connection, options) }

  let(:connection) { double }
  let(:host) { "http://example.com/xi" }
  let(:version) { "v2" }
  let(:retriable_intervals) { [] }

  let(:response) { instance_double(Faraday::Response, body:) }
  let(:body) { "{}" }
  let(:parser) { double(parse: {}) }

  let(:options) do
    {
      host:,
      retriable_intervals:,
      version:,
    }
  end

  describe ".build" do
    let(:host) { "http://localhost" }

    it "builds a Uktt::Http client instance" do
      expect(described_class.build(host, version, retriable_intervals)).to be_a(described_class)
    end
  end

  describe "#retrieve" do
    before do
      allow(connection).to receive(:get).and_return(response)
      allow(Uktt::JsonApiParser).to receive(:new).and_return(parser)
    end

    let(:expected_headers) { { "Content-Type" => "application/json" } }
    let(:expected_body) { {} }

    it "makes a get request with the correct resource, query and headers" do
      client.retrieve("commodities/1234567890")

      expect(connection).to have_received(:get).with(
        "http://example.com/xi/api/v2/commodities/1234567890",
        {},
        { "Content-Type" => "application/json" },
      )
    end

    context "when a query is passed" do
      it "uses the correct full url with the query constructed" do
        client.retrieve("commodities/1234567890", "filter[geographical_area_id]" => "RO", "as_of" => "2022-09-11")

        expect(connection).to have_received(:get).with(
          "http://example.com/xi/api/v2/commodities/1234567890",
          { "as_of" => "2022-09-11", "filter[geographical_area_id]" => "RO" },
          { "Content-Type" => "application/json" },
        )
      end
    end
  end
end
