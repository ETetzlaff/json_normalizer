require_relative 'lib/json_normalizer'

y = {
  city: ["City"],
  disciplinary_action: ["Disciplinary Action"],
  license_number: ["License Number"],
  license_type: ["License Type"],
  licenses: ["Licenses"],
  license_expiration_date: ["License Expiration Date"],
  license_issue_date: ["License Issue Date"],
  license_status: ["License Status"],
  original_license_date: ["Original License Date"],
  name: ["Name"],
  state: ["State"]
}

j = JsonNormalizer.new(y.to_json)

test_row = {"":"1161049 586062 View Detail","City":"Harrison","Name":"Colleen E. Mitchell","State":"NE","Status":"Active","Licenses":[{"License Type":"Individual Controlled Substance Registration","License Number":"CS00322","License Status":"Active","License Issue Date":"10/31/2014","Original License Date":"10/31/2014","License Expiration Date":"6/30/2016"}],"License Type":"Individual Controlled Substance Registration","License Number":"CS00322","Disciplinary Action":"None"}

puts JSON.pretty_generate j.translate(JSON.parse(test_row.to_json))
