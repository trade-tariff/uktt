RSpec.describe Uktt::Heading, :http do
  subject(:heading) { described_class.new(http) }

  let(:heading_id) { "0101" }

  describe "#retrieve" do
    it "retrieves one heading" do
      parsed = heading.retrieve(heading_id)
      expect(parsed).to be_an_instance_of(Hash)
      expect(parsed["goods_nomenclature_item_id"]).to eq("#{heading_id}000000")
    end
  end

  describe "#changes" do
    it "retrieves one heading's changes as JSON" do
      parsed = heading.changes(heading_id)
      expect(parsed).to be_an_instance_of(Array)
      expect(parsed.first).to have_key("oid")
    end
  end

  describe "#goods_nomenclatures" do
    it "retrieves goods nomenclatures for a heading" do
      parsed = heading.goods_nomenclatures(heading_id)

      expect(parsed).to be_an_instance_of(Array)
      expect(parsed.first["goods_nomenclature_item_id"]).to eq("#{heading_id}000000")
    end
  end
end
