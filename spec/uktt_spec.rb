require 'uktt'

RSpec.describe Uktt do
  it 'has a version number and is in the correct format' do
    expect(Uktt::VERSION).not_to be(nil)
    expect(Uktt::VERSION).to match(/^\d+\.\d+\.\d+$/)
  end
end
