require "spec_helper"
describe ID3Tag::ID3V2FrameParser do
  subject { described_class.new(frame_bytes, tag_major_version) }

  context "parsing v2.2.x tag" do
    let(:tag_major_version) { 2 }
    let(:frame_bytes) { "TP2\u0000\u0000\u0004\u0000ABC" + "TP1\u0000\u0000\u0004\u0000DEF" }
    it "should fabricate frames" do
      expect(ID3Tag::Frames::V2::FrameFabricator).to receive(:fabricate).with('TP2', "\u0000ABC", nil, 2).once
      expect(ID3Tag::Frames::V2::FrameFabricator).to receive(:fabricate).with('TP1', "\u0000DEF", nil, 2).once
      subject.frames
    end
  end
  context "parsing v2.2.3 tag" do
    let(:tag_major_version) { 3 }
    let(:frame_bytes) { "TIT2\u0000\u0000\u0000\u0004\u0000\u0000\u0000ABC" + "TIT1\u0000\u0000\u0000\u0004\u0000\u0000\u0000DEF" }
    it "should fabricate frames" do
      expect(ID3Tag::Frames::V2::FrameFabricator).to receive(:fabricate).with('TIT2', "\u0000ABC", "\u0000\u0000", 3).once
      expect(ID3Tag::Frames::V2::FrameFabricator).to receive(:fabricate).with('TIT1', "\u0000DEF", "\u0000\u0000", 3).once
      subject.frames
    end
  end
  context "parsing v2.4.x tag" do
    let(:tag_major_version) { 4 }
    let(:frame_bytes) { "TIT2\u0000\u0000\u0000\u0004\u0000\u0000\u0000ABC" + "TIT1\u0000\u0000\u0000\u0004\u0000\u0000\u0000DEF" }
    it "should fabricate frames" do
      expect(ID3Tag::Frames::V2::FrameFabricator).to receive(:fabricate).with('TIT2', "\u0000ABC", "\u0000\u0000", 4).once
      expect(ID3Tag::Frames::V2::FrameFabricator).to receive(:fabricate).with('TIT1', "\u0000DEF", "\u0000\u0000", 4).once
      subject.frames
    end
  end

  context "using truncated tag body" do
    let(:tag_major_version) { 4 }
    let(:frame_bytes) { "TIT2\u0000\u0000\u0000\u0004\u0000\u0000\u0000ABC" + "TIT1\u0000\u0000\u0000\u0004\u0000\u0000" }
    it "should fabricate frames until unexpected eof" do
      frames = subject.frames
      expect(frames.size).to eq(1)
      expect(frames[0].id).to eq(:TIT2)
    end
  end
end
