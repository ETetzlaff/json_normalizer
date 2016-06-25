require 'json'
require 'byebug'

class JsonNormalizer

  # Init requires pre defined JSON map.
  # Ex. { "this_key": ["morphed", "to", "this_key"] }
  def initialize(map)
    @map = JSON.parse(map)
    @result = {}
  end

  def fetch_key(key)
    @map.keys.each{ |k| return k if @map[k].include?(key) }
  end

  def fetch_new_keys(json)
    # Returns a list of keys provided in the json that are not listed in the pre-defined mapping
    @keys = list_keys_in_mapping
    @not_defined = []
    json = JSON.parse(json) if ![Hash, Array].include?(json.class)

    json.each do |key, value|
      if value.is_a?(Array)
        value.each { |v| fetch_new_keys(v) if v.respond_to?(:keys) }
      elsif value.respond_to?(:keys)
        value.each { |k, v| @not_defined << k unless @keys.include?(key); fetch_new_keys(v) if v.respond_to?(:keys); }
      end
      @not_defined << key unless @keys.include?(key)
    end

    @not_defined
  end

  def key_contained?(key)
    @map.keys.each{ |k| return true if @map[k].include?(key.to_s) }
    return false
  end

  def list_keys_in_mapping()
    @keys = []
    @map.each do |new_key, transform_keys|
      transform_keys.each { |key| @keys << key }
    end
    @keys
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
end
