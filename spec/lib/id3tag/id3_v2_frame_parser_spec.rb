require "spec_helper"
describe ID3Tag::ID3V2FrameParser do
  let(:mp3_with_v2_3_tag) { mp3_fixture('id3v2.mp3') }
  let(:frame_bytes) { File.read(mp3_with_v2_3_tag, 246, 10) }
  let(:tag_major_version) { 3 }
  describe "#frames" do
    subject { described_class.new(frame_bytes, tag_major_version).frames }
    it "should have frame TIT2" do
      subject.select { |x| x.id == :TIT2 }.count.should == 1
    end

    describe "text frames" do
      it "should parse text frames and initialize as TextFrame objects" do
        subject.select { |x| x.id == :TIT2 }.first.should be_kind_of(ID3Tag::Frames::V2::TextFrame)
      end
    end
  end
end
