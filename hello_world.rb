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

output_file = ARGV[1]
input_file = ARGV[0]

File.open(output_file, 'w') do |out|
  File.open(input_file, 'r').each_line do |line|
    line.chomp!
    #@linecount += 1

    mmsid, oclcnum = line.split(/\t/)
    mmsid.strip!
    oclcnum.strip!

    url = "/webservices/catalog/content/#{oclcnum}"

    resp = connection.public_send(:get, url, query)
    #puts JSON.pretty_generate(JSON.parse(resp.body))

    reader = MARC::XMLReader.new(StringIO.new(resp.body))
    reader.each do |record|
  
    oclc001 = record.fields("001").map{|f|f.value}  
    if record.fields("019").empty?
      #puts mmsid
      #puts record.fields("001")
      #oclc001 = record.fields("001").map{|f|f.value}
      out.print "#{mmsid}\t#{oclc001}\n"
    else
      oclc019 = record.fields("019").first.subfields.map{|f|f.value}
      #puts mmsid 
      #puts record.fields("001")
      #puts record.fields("019").first.subfields.map{|f|f.value}
      out.print "#{mmsid}\t#{oclc001}\t#{oclc019}\n"
    end
  end
end
end