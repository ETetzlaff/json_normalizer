Gem::Specification.new do |s|
  s.name = 'json_normalizer'
  s.version = '0.3.1'
  s.date = '2016-05-01'
  s.summary = 'Normalizes JSON Doc Schema.'
  s.description = 'Normalizes disparate JSON Schemas to Specified Schema'
  s.authors = ['Evan Tetzlaff']
  s.email = 'reuhssurance@gmail.com'
  s.files = ['lib/json_normalizer.rb']
  s.homepage = 'http://rubygems.org/gems/json_normalizer'
  s.license = 'MIT'

  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "byebug"
end
