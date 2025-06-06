RSpec.describe Uktt::Country do
  subject(:country) { described_class.new(http) }

  let(:http) { instance_double(Uktt::Http) }

  describe "#retrieve_all" do
    it "performs a retrieve of countries" do
      allow(http).to receive(:retrieve).with("geographical_areas/countries.json", {})

      country.retrieve_all

      expect(http).to have_received(:retrieve).with("geographical_areas/countries.json", {})
    end
  end
end
