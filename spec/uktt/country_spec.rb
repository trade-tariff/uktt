RSpec.describe Uktt::Country do
  subject(:country) { described_class.new(http) }

  let(:http) { instance_double('Uktt::Http') }

  describe '#retrieve' do
    it 'performs a retrieve of countries' do
      allow(http).to receive(:retrieve).with('geographical_areas/countries', {})

      country.retrieve
    end
  end
end
