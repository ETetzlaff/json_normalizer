require 'spec_helper'

describe Json_Normalizer do
  before :each do
    @normalizer = Json_Normalizer.new({returned: [:given]}.to_json)
  end

  it 'successfully creates the normalizer' do
    expect(@normalizer).to be_an_instance_of Json_Normalizer
  end

  it 'sets map' do
    expect(@normalizer.instance_variable_get(:@map)).to eql(JSON.parse({ returned: [:given] }.to_json))
  end

  it 'can check if a key is contained in the map' do
    expect(@normalizer.key_contained?(:given)).to be_truthy
  end

  it 'fetches the normalized key' do
    expect(@normalizer.fetch_key(:given).first).to eql "returned"
  end

  it 'successfully translates given the mapping' do
    expect(@normalizer.translate({given: 'test'})).to eql(JSON.parse({returned: 'test'}.to_json))
  end
end
