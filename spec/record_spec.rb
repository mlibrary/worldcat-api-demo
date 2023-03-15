describe Record do
  def get_record(path)
    reader = MARC::XMLReader.new(path)
    for r in reader
      return r
    end
  end
  let(:no_019) do
    get_record('./spec/fixtures/record.xml')
  end
  let(:has_019) do
    get_record('./spec/fixtures/record_with_019.xml')
  end
  subject do
    described_class.new(no_019) 
  end
  it "gets the 001 from the oclc worldcat record" do
    expect(subject.oclc001).to eq("1371295450")
  end
  
  context "#oclc019" do
    it "returns empty string when there aren't any 019s" do
      expect(subject.oclc019).to eq("")
    end
    it "returns array of old oclc numbers there is an 019" do
      expect(Record.new(has_019).oclc019).to eq(["1329221766"])
    end
  end

end
