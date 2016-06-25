require 'json'

class JsonNormalizer

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
      json[self.fetch_key(key)] = json[key]
      json.delete(key)
    end
  end

  def translate(json)
    json = JSON.parse(json) if ![Hash, Array].include?(json.class)
    if json.is_a?(Array)
      json.each do |j|
        translate(j)
      end
    else
      json.keys.each do |key|
        if json[key].is_a?(Array)
          translate(json[key])
          swap_key(json,key)
        else
          if json[key].respond_to?(:keys)
            translate(json[key])
          end
          swap_key(json,key)
        end
      end
    end
    json
  end

  def translate_array_of_docs(json_docs)
    results = []
    json_docs.each { |doc| results << translate(doc) }
    results
  end
end
