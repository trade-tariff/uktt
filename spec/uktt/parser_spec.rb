RSpec.describe Uktt::Parser do
  subject(:parser) { described_class.new(body, format) }

  let(:body) { read_file("#{json_file}.json") }
  let(:json_file) { 'commodity' }

  context 'when parsing to ostruct' do
    let(:format) { 'ostruct' }

    it 'returns valid OpenStruct' do
      expect(parser.parse).to be_a(OpenStruct)
    end
  end

  context 'when parsing to json' do
    let(:format) { 'json' }

    it 'returns valid raw json' do
      expect(parser.parse).to eq(body)
    end
  end

  context 'when parsing to jsonapi' do
    let(:format) { 'jsonapi' }
    let(:schema) { parse_file('schemas/commodity.json') }

    it 'returns valid jsonapi' do
      parsed = parser.parse
      valid = JSON::Validator.validate(schema, parsed)
      expect(valid).to be(true)
    end
  end

  context 'when parsing to an unknown format' do
    let(:format) { 'foo' }

    it 'propagates an error' do
      expect { parser.parse }.to raise_error(ArgumentError, 'Specified invalid format foo')
    end
  end

  context 'with singular resource' do
    subject(:parsed) { parser.parse }

    let(:format) { 'jsonapi' }

    context 'with valid' do
      let(:json_file) { 'singular_no_relationship' }

      it { is_expected.to include 'meta' => { 'foo' => 'bar' } }
      it { is_expected.to include 'name' => 'Joe' }
      it { is_expected.to include 'age' => 21 }
    end

    context 'without attributes field' do
      let(:json_file) { 'singular_no_attributes' }

      it { is_expected.to include 'meta' => { 'foo' => 'bar' } }
      it { is_expected.not_to include 'name' }
    end

    context 'with relationships' do
      let(:json_file) { 'singular_with_relationship' }

      it { is_expected.to include 'meta' => { 'foo' => 'bar' } }
      it { is_expected.to include 'name' => 'Joe' }
      it { is_expected.to include 'age' => 21 }
      it { is_expected.to include 'parts' => [{ 'id' => 456, 'meta' => { 'foo' => 'bar' }, 'part_name' => 'A part name' }] }
    end

    context 'with valid missing relationship' do
      let(:json_file) { 'singular_valid_null_singular_relationship' }

      it { is_expected.to include 'meta' => { 'foo' => 'bar' } }
      it { is_expected.to include 'name' => 'Joe' }
      it { is_expected.to include 'age' => 21 }
      it { is_expected.to include 'part' => nil }
    end

    context 'with missing relationships' do
      let(:json_file) { 'singular_missing_relationship' }

      it { is_expected.to include 'meta' => { 'foo' => 'bar' } }
      it { is_expected.to include 'name' => 'Joe' }
      it { is_expected.to include 'age' => 21 }
      it { is_expected.to include 'parts' => [{}] }
    end

    context 'with invalid relationships' do
      let(:json_file) { 'singular_invalid_relationship' }

      it 'raises a description exception' do
        expect { parsed }.to raise_exception \
          described_class::JsonApi::ParsingError,
          "Error finding relationship 'parts': nil"
      end
    end
  end

  context 'with array resource' do
    subject(:parsed) { parser.parse.first }

    let(:format) { 'jsonapi' }

    context 'with valid' do
      let(:json_file) { 'multiple_no_relationship' }

      it { is_expected.to include 'meta' => { 'foo' => 'bar' } }
      it { is_expected.to include 'name' => 'Joe' }
      it { is_expected.to include 'age' => 21 }
    end

    context 'with relationships' do
      let(:json_file) { 'multiple_with_relationship' }

      it { is_expected.to include 'meta' => { 'foo' => 'bar' } }
      it { is_expected.to include 'name' => 'Joe' }
      it { is_expected.to include 'age' => 21 }
      it { is_expected.to include 'parts' => [{ 'id' => 456, 'meta' => { 'foo' => 'bar' }, 'part_name' => 'A part name' }] }
    end

    context 'with missing relationships' do
      let(:json_file) { 'multiple_missing_relationship' }

      it { is_expected.to include 'meta' => { 'foo' => 'bar' } }
      it { is_expected.to include 'name' => 'Joe' }
      it { is_expected.to include 'age' => 21 }
      it { is_expected.to include 'parts' => [{}] }
    end

    context 'with invalid relationships' do
      let(:json_file) { 'multiple_invalid_relationship' }

      it 'raises a description exception' do
        expect { parsed }.to raise_exception \
          described_class::JsonApi::ParsingError,
          "Error finding relationship 'parts': nil"
      end
    end
  end
end
