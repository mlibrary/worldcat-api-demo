require "faraday"
require "marc"
require "byebug"
require "stringio"
connection = Faraday.new(
  url: "http://worldcat.org"
) do |f|
  # f.response :logger, nil, {headers: true, bodies: true}
  f.request :json
  f.response :json
end

query = {
  servicelevel: "full",
  wskey: ENV.fetch("WORLDCAT_API_KEY"),
  format: "json"
}

url = "/webservices/catalog/content/60082813"

resp = connection.public_send(:get, url, query)
#puts JSON.pretty_generate(JSON.parse(resp.body))

reader = MARC::XMLReader.new(StringIO.new(resp.body))
reader.each do |record|
  puts record.fields("019").first.subfields.map{|f|f.value}
end