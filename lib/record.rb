class Record
  def initialize(record)
    @record = record
  end
  def oclc001
    @record.fields("001").map{|f| f.value }.first
  end
  def oclc019
    base_019 = @record.fields("019")
    return "" if base_019&.first.nil?
    base_019.first.subfields.map{|f| f.value } || ""
  end
  def to_s
    "#{oclc001}\t#{oclc019}"
  end

end
