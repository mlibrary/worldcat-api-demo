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

class Record
  def initialize(record)
    @record = record
  end
  def oclc001
    @record.field("001").map{|f| f.value }
  end
  def oclc019
    base_019 = @record.field("019")
    return "" if base_019.nil?
    base_019.first.subfields.map{|f| f.value } || ""
  end
  def to_s
    "#{oclc001}\t#{oclc019}"
  end

end



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
      my_record = Record.new(record)
      #you probably don't need the to_s
      out.print "#{mmsid}\t#{my_record.to_s}\n"
    end
  end
end
