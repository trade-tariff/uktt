RSpec.describe Uktt::Chapter, :http do
  subject(:chapter) { described_class.new(http) }

  let(:chapter_id) { "01" }

  describe "#retrieve" do
    it "retrieves one chapter" do
      parsed = chapter.retrieve(chapter_id)

      expect(parsed).to be_an_instance_of(Hash)
      expect(parsed["goods_nomenclature_item_id"]).to eq("#{chapter_id}00000000")
    end
  end

  describe "#changes" do
    it "retrieves one chapter's changes" do
      parsed = chapter.changes(chapter_id)
      expect(parsed).to be_an_instance_of(Array)
      expect(parsed.first["oid"]).to be_an_instance_of(Integer)
    end
  end

  describe "#retrieve_all" do
    it "retrieves all chapters as JSON" do
      parsed = chapter.retrieve_all
      expect(parsed).to be_an_instance_of(Array)
      expect(parsed.length).to eq(98)
    end
  end

  describe "#goods_nomenclatures" do
    it "retrieves goods nomenclatures for a chapter" do
      parsed = chapter.goods_nomenclatures(chapter_id)

      expect(parsed).to be_an_instance_of(Array)
      expect(parsed.first["goods_nomenclature_item_id"][0..1]).to eq(chapter_id)
    end
  end
end
