require 'json'
require 'byebug'

class Json_Normalizer

  # Init requires pre defined JSON map.
  # Ex. { "this_key": ["morphed", "to", "this_key"] }
  def initialize(map)
    @map = JSON.parse(map)
    @result = {}
  end

  def key_contained?(key)
    @map.keys.each{ |k| return true if @map[k].include?(key.to_s) }
    return false
  end

  def fetch_key(key)
    @map.keys.each{ |k| return k if @map[k].include?(key) }
  end

  def swap_key(json, key)
    if self.key_contained?(key)
      json[self.fetch_key(key).first] = json[key]
      json.delete(key)
    else
      # if we want to move out non-normalized keys into a different 'misc' key or something
    end
  end

  def translate(json)
    json = JSON.parse(json) if !json.is_a?(Hash)
    json.keys.each do |key|
      if json[key].respond_to?(:each)
        puts "Key: #{key} recursing..."
        self.translate(json[key])
        self.swap_key(json, key)
      else
        self.swap_key(json, key)
      end
    end

    # json.map{ |k, v| [k.to_s, v] }.to_h
    JSON.parse json.to_json
  end

end
