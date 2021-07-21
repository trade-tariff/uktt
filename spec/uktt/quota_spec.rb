RSpec.describe Uktt::Quota, :http do
  subject(:quota) { described_class.new(http) }

  describe '#search' do
    let(:params) do
      {
        day: '15',
        month: '02',
        year: '2021',
        geographical_area_id: 'IL',
        order_number: '051341',
      }
    end

    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'performs a search' do
        response = quota.search(params)

        expect(response.data.first.attributes.quota_order_number_id).to eq(params[:order_number])
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it 'performs a search' do
        response = JSON.parse(quota.search(params), symbolize_names: true)

        expect(response[:data].first[:attributes][:quota_order_number_id]).to eq(params[:order_number])
      end
    end
  end
end
