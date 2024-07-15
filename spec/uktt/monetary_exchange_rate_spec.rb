RSpec.describe Uktt::MonetaryExchangeRate do
  subject(:resource) { described_class.new(http) }

  let(:http) { instance_double(Uktt::Http) }

  describe '#retrieve_all' do
    it 'performs a retrieve of monetary_exchange_rates' do
      allow(http).to receive(:retrieve)

      resource.retrieve_all

      expect(http).to have_received(:retrieve).with('monetary_exchange_rates.json', {})
    end
  end
end
