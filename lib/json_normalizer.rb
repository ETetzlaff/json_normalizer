require 'json'

class JsonNormalizer

  # Init requires pre defined JSON map.
  # Ex. { "this_key": ["morphed", "to", "this_key"] }
  def initialize(map)
    @map = make_hash(map)
    @mapped_keys = mapped_keys
    @keymap = keymap
  end

  def key_contained?(key)
    @mapped_keys.include?(key)
  end

  def fetch_key(key)
    @keymap[key]
  end

  def swap_key(json, key)
    if self.key_contained?(key)
      json[fetch_key(key)] = json.delete(key)
    end
  end

  def batch_translate(batch=[])
    batch.map!{|item| make_hash(item) }.map!{|item| deep_translate(item) }
    batch
  end

  def make_hash(item)
    [Hash, Array].include?(item.class) ? item : JSON.parse(item)
  end

  def translate(json)
    json = make_hash(json)
    deep_translate(json)
  end

  def deep_translate(json)
    if json.is_a?(Array)
      json.each do |j|
        translate(j) if [Hash, Array].include?(j.class)
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

  ##### SETTERS #####
  def keymap
    km = {}
    @map.each {|k,v| v.each{ |old_key| km.merge!({old_key => k}) } }
    km
  end

  def mapped_keys
    @map.values.flatten
  end
end
