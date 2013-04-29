require "spec_helper"

describe ID3Tag do
  let(:file) { mp3_fixture('id3v2.mp3') }
  describe "#read" do
    it "reads file tag" do
      ID3Tag.read(file).should be_instance_of(ID3Tag::Tag)
    end

    it "accepts block" do
      expect do |b|
        ID3Tag.read(file, &b)
      end.to yield_control
    end
  end
end

