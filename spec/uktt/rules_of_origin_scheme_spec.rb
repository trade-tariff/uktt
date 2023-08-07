RSpec.describe Uktt::RulesOfOriginScheme, :http do
  subject(:rules_of_origin_scheme) { described_class.new(http) }

  let(:http) { instance_double('Uktt::Http') }

  describe '#retrieve_all' do
    it 'performs a retrieve of countries' do
      allow(http).to receive(:retrieve).with('rules_of_origin_schemes.json', { heading_code: '050100', country_code: 'RO' })

      rules_of_origin_scheme.retrieve_all(heading_code: '050100', country_code: 'RO')
    end
  end
end
