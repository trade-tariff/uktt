RSpec.describe Uktt::Commodity, :http do
  subject(:commodity) { described_class.new(http) }

  let(:commodity_id) { "0101210000" }

  describe "#retrieve" do
    it "retrieves one commodity" do
      parsed = commodity.retrieve(commodity_id)
      expect(parsed).to be_an_instance_of(Hash)
      expect(parsed["goods_nomenclature_item_id"]).to eq(commodity_id)
    end
  end

  describe "#changes" do
    it "retrieves one commodity's changes" do
      parsed = commodity.changes(commodity_id)
      expect(parsed).to be_an_instance_of(Array)
      expect(parsed.first["oid"]).to be_an_instance_of(Integer)
    end
  end
end
