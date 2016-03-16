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
        expect(frame.content).to eq("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaA")
      end

      it "should contain artist frame" do
        frame = subject.select { |frame| frame.id == :artist }.first
        expect(frame.content).to eq("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbB")
      end

      it "should contain album frame" do
        frame = subject.select { |frame| frame.id == :album }.first
        expect(frame.content).to eq("cccccccccccccccccccccccccccccC")
      end

      it "should contain year frame" do
        frame = subject.select { |frame| frame.id == :year }.first
        expect(frame.content).to eq("2003")
      end
    end

    describe "frames with differences in v1.0 and v1.1" do
      context "when reading v1.0 tag" do
        it "should contain comments frame" do
          frame = subject.select { |frame| frame.id == :comments }.first
          expect(frame.content).to eq("dddddddddddddddddddddddddddddD")
        end

        it "should contain genre frame" do
          frame = subject.select { |frame| frame.id == :genre }.first
          expect(frame.content).to eq("Blues")
        end

        it "should not contain track nr frame" do
          expect(subject.select { |frame| frame.id == :track_nr }.first).to be_nil
        end
      end
      context "when reading v1.1 tag" do
        subject { described_class.new(frame_bytes_v1_1).frames }
        it "should contain comments frame" do
          frame = subject.select { |frame| frame.id == :comments }.first
          expect(frame.content).to eq("dddddddddddddddddddddddddddD")
        end

        it "should contain track nr frame" do
          frame = subject.select { |frame| frame.id == :track_nr }.first
          expect(frame.content).to eq("1")
        end
      end
    end
  end

  describe "Test with real-world tag" do
    let(:tag_body) { File.read mp3_fixture("pov_20131018-2100a.mp3.v1_tag_body") }
    subject { described_class.new(tag_body) }
    it "have title" do
      expect(subject.frames.find { |f| f.id == :title }.content).to eq("pov_20131018-2100a.mp3")
    end
  end
end
