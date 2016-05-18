# JSON Normalizer

### What is it?
Json Normalizer is a gem that normalizes keys on json documents from disparate sources.
The process will attempt to translate EVERY key given the mapping; including keys in nested documents.

### Usage

```ruby
require 'json_normalizer'

mapping = { returned_key: [:given, :keys] }

normalizer = Json_Normalizer.new(mapping.to_json)

doc_to_be_normalized = { given: { keys: 'both keys will be translated!' } }

normalized = normalizer.translate(doc_to_be_normalized)
```

