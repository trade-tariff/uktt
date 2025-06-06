RSpec.describe Uktt::Section, :http do
  subject(:section) { described_class.new(http) }

  let(:section_id) { "1" }

  describe "#retrieve" do
    let(:format) { "json" }

    it "retrieves one section" do
      parsed = section.retrieve(section_id)

      expect(parsed).to be_an_instance_of(Hash)
      expect(parsed["position"].to_s).to eq(section_id)
    end
  end

  describe "#retrieve_all" do
    it "retrieves all sections" do
      parsed = section.retrieve_all

      expect(parsed).to be_an_instance_of(Array)
      expect(parsed.length).to eq(21)
    end
  end

  describe "#goods_nomenclatures" do
    it "retrieves goods nomenclatures for a section" do
      parsed = section.goods_nomenclatures(section_id)

      expect(parsed).to be_an_instance_of(Array)
      expect(parsed.first["goods_nomenclature_item_id"]).to be_an_instance_of(String)
    end
  end
end
