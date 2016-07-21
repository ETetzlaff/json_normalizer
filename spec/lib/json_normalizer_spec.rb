require 'spec_helper'

describe JsonNormalizer do
  before :each do
    mapping = "{\"testing\": [\"Testing\"], \"key_map\": [\"Key Mapping\"], \"arbitrary\": [\"Some Key Here\"]}"
    @non_normal = "{\"Testing\":\"VALUE_TESTING\",\"Key Mapping\":\"VALUEKEYMAP\",\"Some Key Here\":\"ARBITRARY\"}"
    @normal = {"testing"=>"VALUE_TESTING", "key_map"=>"VALUEKEYMAP", "arbitrary"=>"ARBITRARY"}
    @normalizer = JsonNormalizer.new(mapping)
  end

  it 'successfully creates the normalizer' do
    expect(@normalizer).to be_an_instance_of JsonNormalizer
  end

  it 'sets map' do
    expect(@normalizer.instance_variable_get(:@map)).to eql({"testing"=>["Testing"], "key_map"=>["Key Mapping"], "arbitrary"=>["Some Key Here"]})
  end

  it 'sets mapped_keys' do
    expect(@normalizer.instance_variable_get(:@mapped_keys)).to eql(["Testing", "Key Mapping", "Some Key Here"])
  end

  it 'sets keymap' do
    expect(@normalizer.instance_variable_get(:@keymap)).to  eql({"Testing"=>"testing", "Key Mapping"=>"key_map", "Some Key Here"=>"arbitrary"})
  end

  it 'can check if a key is contained in the map' do
    expect(@normalizer.key_contained?("Key Mapping")).to be_truthy
  end

  it 'returns false if key is not contained anywhere in map' do
    expect(@normalizer.key_contained?(:not_given)).to be_falsey
  end

  it 'fetches the normalized key' do
    expect(@normalizer.fetch_key("Key Mapping")).to eql "key_map"
  end

  it 'successfully translates given the mapping' do
    expect(@normalizer.translate({"Testing" => 'test_val'})).to eql({"testing" => 'test_val'})
  end

  it 'successfully translates nested' do
    expect(@normalizer.translate(JSON.parse({"Key Mapping": {"Some Key Here": 'test'}}.to_json))).to eql(JSON.parse({"key_map": {"arbitrary": 'test'}}.to_json))
  end

  it 'successfully translates n sub documents' do
    expect(@normalizer.translate(JSON.parse({"Testing": {"Testing": {"Testing": 'test'}}}.to_json))).to eql(JSON.parse({testing: {testing: {testing: 'test'}}}.to_json))
  end

  it 'successfully translates arrays as values' do
    expect(@normalizer.translate(JSON.parse({"Some Key Here": [{"Testing": 'test'}]}.to_json))).to eql(JSON.parse({"arbitrary": [{"testing": 'test'}]}.to_json))
  end

  it 'retains key values of items not contained in the map' do
    expect(@normalizer.translate(JSON.parse({"test": {"test_two": "test"}}.to_json))).to eql(JSON.parse({"test": {"test_two": "test"}}.to_json))
  end

  it 'successfully translates values that are arrays of arrays' do
    expect(@normalizer.translate(JSON.parse({"testing": [[{"stuff": "things"}],[{"stuff1":  "things1"}]]}.to_json))).to eql(JSON.parse({"testing": [[{"stuff": "things"}], [{"stuff1": "things1"}]]}.to_json))
  end

  it 'successfully translates batches' do
    batch = []; expected = [];
    1000.times{|n| batch << @non_normal; expected << @normal }
    expect(@normalizer.batch_translate(batch)).to eql(expected)
  end

  it 'returns Hash or Array from make_hash if already Hash or Array' do
    expect(@normalizer.make_hash({this: :is, a: :test}).class).to eql(Hash)
    expect(@normalizer.make_hash([{this: :is},{a: :test},{test: :test}]).class).to eql(Array)
  end

  it 'returns a Hash or Array from make_hash if passed a JSON string' do
    expect(@normalizer.make_hash("{\"Testing\":\"VALUE_TESTING\",\"Key Mapping\":\"VALUEKEYMAP\",\"Some Key Here\":\"ARBITRARY\"}").class).to eql(Hash)
    expect(@normalizer.make_hash("[{\"Testing\":\"VALUE_TESTING\",\"Key Mapping\":\"VALUEKEYMAP\",\"Some Key Here\":\"ARBITRARY\"}]").class).to eql(Array)
  end

  it 'parses keys with colons and string value' do
    expect(@normalizer.translate('{"Key with colon:":"string val"}')).to eql({'Key with colon:' => 'string val'})
  end

  it 'parses keys with colons and array value' do
    expect(@normalizer.translate('{"Key with colon:" : ["array val1", "array val2"]}')).to eql({'Key with colon:' => ['array val1', 'array val2']})
  end
end
