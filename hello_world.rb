require "faraday"
connection = Faraday.new(
  url: "http://worldcat.org"
) do |f|
  # f.response :logger, nil, {headers: true, bodies: true}
  f.request :json
  f.response :json
end

query = {
  maximumLibraries: 50,
  location: 48103,
  wskey: ENV.fetch("WORLDCAT_API_KEY"),
  format: "json"
}

url = "/webservices/catalog/content/libraries/6961296"

resp = connection.public_send(:get, url, query)
puts JSON.pretty_generate(JSON.parse(resp.body))
