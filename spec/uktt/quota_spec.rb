RSpec.describe Uktt::Quota, :http do
  subject(:quota) { described_class.new(http) }

  describe "#search" do
    let(:params) do
      {
        day: "15",
        month: "02",
        year: "2021",
        geographical_area_id: "IL",
        order_number: "051341",
      }
    end

    it "performs a search" do
      parsed = quota.search(params)

      expect(parsed.first["quota_order_number_id"]).to eq(params[:order_number])
    end
  end
end
