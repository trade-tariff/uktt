RSpec.describe Uktt::GeographicalArea do
  subject(:geographical_area) { described_class.new(http) }

  let(:http) { instance_double('Uktt::Http') }

  describe '#retrieve' do
    it 'performs a retrieve of geographical_areas' do
      allow(http).to receive(:retrieve).with('geographical_areas', {})

      geographical_area.retrieve
    end
  end
end
