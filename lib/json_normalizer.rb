require 'json'
require 'byebug'

class Json_Normalizer

  # Init requires pre defined JSON map.
  # Ex. { "this_key": ["morphed", "to", "this_key"] }
  def initialize(map)
    @map = JSON.parse(map)
    @result = {}
  end

  def is_value_raised?(value)
    value.respond_to?(:each)
  end

  def key_contained?(key)
    @map.keys.each{ |k| @map[k].include?(key) ? true : false }
  end

  def fetch_key(key)
    @map.keys.each{ |k| return k if @map[k].include?(key) }
  end

  # def judge_set(set)
  #   if self.key_contained?(key)
  #     json[self.fetch_key(key)] = json[key]
  #     json.delete(key)
  #   else
  #     byebug
  #     json[:misc].append({ key: json[key] })
  #   end
  # end

  def translate(json)
    json = JSON.parse(json) if !json.is_a?(Hash)
    json.keys.each do |key|
      if json[key].respond_to?(:each)
        puts "Key: #{key} recursing..."
        self.translate(json[key])

        if self.key_contained?(key)
          json[self.fetch_key(key).first] = json[key]
          json.delete(key)
        else
          byebug
          json[:misc].append({ key: json[key] })
        end
      else
        if self.key_contained?(key)
          json[self.fetch_key(key).first] = json[key]
          json.delete(key)
        else
          byebug
          json[:misc].append({ key: json[key] })
        end
      end
    end

    json
    # @result
  end

end
