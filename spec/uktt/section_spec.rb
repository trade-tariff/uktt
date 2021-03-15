RSpec.describe Uktt::Section, :http do
  subject(:section) { described_class.new(http) }

  let(:section_id) { '1' }

  describe '#retrieve' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'retrieves one section' do
        expect(section.retrieve(section_id).data.attributes.position.to_s).to eq(section_id)
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it 'retrieves one section' do
        response = JSON.parse(section.retrieve(section_id), symbolize_names: true)

        expect(response).to be_an_instance_of(Hash)
        expect(response[:data][:attributes][:position].to_s).to eq(section_id)
      end
    end
  end

  describe '#note' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it "retrieves one section's note as OpenStruct" do
        expect(section.note(section_id).section_id.to_s).to eq(section_id)
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it "retrieves one section's note" do
        response = JSON.parse(section.note(section_id), symbolize_names: true)

        expect(response[:section_id].to_s).to eq(section_id)
      end
    end
  end

  describe '#retrieve_all' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'retrieves all sections as [OpenStructs]' do
        response = section.retrieve_all

        expect(response.data).to be_an_instance_of(Array)
        expect(response.data.length).to eq(21)
        expect(response.data.first).to be_an_instance_of(OpenStruct)
        expect(response.data.first.attributes.position).to eq(1)
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it 'retrieves all sections' do
        response = JSON.parse(section.retrieve_all, symbolize_names: true)

        expect(response[:data]).to be_an_instance_of(Array)
        expect(response[:data].length).to eq(21)
      end
    end
  end

  describe '#goods_nomenclatures' do
    context 'when the format is OpenStruct' do
      let(:format) { 'ostruct' }

      it 'retrieves goods nomenclatures for a section' do
        response = section.goods_nomenclatures(section_id)

        expect(response.data).to be_an_instance_of(Array)
        expect(response.data.first).to be_an_instance_of(OpenStruct)
        expect(response.data.first.attributes).to respond_to(:goods_nomenclature_item_id)
      end
    end

    context 'when the format is json' do
      let(:format) { 'json' }

      it 'retrieves goods nomenclatures for a section' do
        response = JSON.parse(section.goods_nomenclatures(section_id), symbolize_names: true)

        expect(response).to be_an_instance_of(Hash)
        expect(response[:data].first[:attributes][:goods_nomenclature_item_id]).to be_an_instance_of(String)
      end
    end
  end
end
