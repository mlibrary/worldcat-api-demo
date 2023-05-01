require "alma_rest_client"
require "marc"
require "byebug"

mms_id="990019337870106381"

client = AlmaRestClient.client

response = client.get("bibs/#{mms_id}", query: { view: "full", expand: "none" })
#puts response.body
reader = MARC::XMLReader.new(StringIO.new(response.body["anies"].first))
fields = []
reader.each do |record|
  fields.push(record.fields("035").select{ |x| x.value.match?(/OCoLC/) })
end
puts fields
