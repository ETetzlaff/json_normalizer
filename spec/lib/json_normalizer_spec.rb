require 'spec_helper'

describe Json_Normalizer do
  before :each do
    @normalizer = Json_Normalizer.new({returned: ["given"]}.to_json)
  end

  it 'successfully creates the normalizer' do
    expect(@normalizer).to be_an_instance_of Json_Normalizer
  end

  it 'sets map' do
    expect(@normalizer.instance_variable_get(:@map)).to eql(JSON.parse({ "returned": ["given"] }.to_json))
  end

  it 'can check if a key is contained in the map' do
    expect(@normalizer.key_contained?(:given)).to be_truthy
  end

  it 'returns false if key is not contained anywhere in map' do
    expect(@normalizer.key_contained?(:not_given)).to be_falsey
  end

  it 'fetches the normalized key' do
    expect(@normalizer.fetch_key(:given).first).to eql "returned"
  end

  it 'successfully translates given the mapping' do
    expect(@normalizer.translate(JSON.parse({"given": 'test'}.to_json))).to eql(JSON.parse({"returned": 'test'}.to_json))
  end

  it 'successfully translates nested' do
    expect(@normalizer.translate(JSON.parse({"given": {"given": 'test'}}.to_json))).to eql(JSON.parse({"returned": {"returned": 'test'}}.to_json))
  end

  it 'successfully translates n sub documents' do
    expect(@normalizer.translate(JSON.parse({"given": {"given": {"given": 'test'}}}.to_json))).to eql(JSON.parse({returned: {returned: {returned: 'test'}}}.to_json))
  end

  it 'successfully translates arrays as values' do
    expect(@normalizer.translate(JSON.parse({"given": [{"given": 'test'}]}.to_json))).to eql(JSON.parse({"returned": [{"returned": 'test'}]}.to_json))
  end

  it 'retains key values of items not contained in the map' do
    expect(@normalizer.translate(JSON.parse({"test": {"test_two": "test"}}.to_json))).to eql(JSON.parse({"test": {"test_two": "test"}}.to_json))
  end
end
