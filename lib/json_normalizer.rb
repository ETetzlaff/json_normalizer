require 'json'
require 'byebug'

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
    # json = JSON.parse(json) if !json.is_a?(Hash)
    json = JSON.parse(json) if ![Hash, Array].include?(json.class)
    if json.is_a?(Array)
      json.each do |j|
        j.keys.each do |key|
          if j[key].respond_to?(:each)
            self.translate(j[key])
            self.swap_key(j, key)
          else
            self.swap_key(j, key)
          end
        end
      end
    else
      json.keys.each do |key|
        if json[key].respond_to?(:each)
          self.translate(json[key])
          self.swap_key(json, key)
        else
          self.swap_key(json, key)
        end
      end
    end

    json
  end

end
