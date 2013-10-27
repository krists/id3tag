require "spec_helper"
describe ID3Tag::ID3V1FrameParser do
  let(:mp3_with_v1_0_tag) { mp3_fixture('id3v1_without_track_nr.mp3') }
  let(:mp3_with_v1_1_tag) { mp3_fixture('id3v1_with_track_nr.mp3') }
  let(:frame_bytes_v1_0) { File.read(mp3_with_v1_0_tag, 125, 579) }
  let(:frame_bytes_v1_1) { File.read(mp3_with_v1_1_tag, 125, 579) }
  describe "#frames" do
    subject { described_class.new(frame_bytes_v1_0).frames }

    describe "common frames between v1.0 and v.1.1" do

      it "should contain title frame" do
        frame = subject.select { |frame| frame.id == :title }.first
        frame.content.should == "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaA"
      end

      it "should contain artist frame" do
        frame = subject.select { |frame| frame.id == :artist }.first
        frame.content.should == "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbB"
      end

      it "should contain album frame" do
        frame = subject.select { |frame| frame.id == :album }.first
        frame.content.should == "cccccccccccccccccccccccccccccC"
      end

      it "should contain year frame" do
        frame = subject.select { |frame| frame.id == :year }.first
        frame.content.should == "2003"
      end
    end

    describe "frames with differences in v1.0 and v1.1" do
      context "when reading v1.0 tag" do
        it "should contain comments frame" do
          frame = subject.select { |frame| frame.id == :comments }.first
          frame.content.should == "dddddddddddddddddddddddddddddD"
        end

        it "should contain genre frame" do
          frame = subject.select { |frame| frame.id == :genre }.first
          frame.content.should == "Blues"
        end

        it "should not contain track nr frame" do
          subject.select { |frame| frame.id == :track_nr }.first.should be_nil
        end
      end
      context "when reading v1.1 tag" do
        subject { described_class.new(frame_bytes_v1_1).frames }
        it "should contain comments frame" do
          frame = subject.select { |frame| frame.id == :comments }.first
          frame.content.should == "dddddddddddddddddddddddddddD"
        end

        it "should contain track nr frame" do
          frame = subject.select { |frame| frame.id == :track_nr }.first
          frame.content.should == "1"
        end
      end
    end
  end

  describe "Test with real-world tag" do
    let(:tag_body) { File.read mp3_fixture("pov_20131018-2100a.mp3.v1_tag_body") }
    subject { described_class.new(tag_body) }
    it "have title" do
      subject.frames.find { |f| f.id == :title }.content.should eq("pov_20131018-2100a.mp3")
    end
  end
end
