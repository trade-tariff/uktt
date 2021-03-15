RSpec.describe Uktt::ExchangeRate do
  subject(:exchange_rate) { described_class.new(http) }

  let(:http) { instance_double('Uktt::Http') }

  describe '#retrieve' do
    it 'performs a retrieve of exchange_rates' do
      allow(http).to receive(:retrieve).with('exchange_rates.json', {})

      exchange_rate.retrieve_all
    end
  end
end
