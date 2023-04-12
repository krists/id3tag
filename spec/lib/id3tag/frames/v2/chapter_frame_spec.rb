require "spec_helper"

describe ID3Tag::Frames::V2::ChapterFrame do
  let(:id) { "CHAP" }
  let(:raw_content) do
    [
      element_id,
      separator,
      [start_time].pack("N"),
      [end_time].pack("N"),
      [start_offset].pack("N"),
      [end_offset].pack("N"),
      raw_subframe
    ].join
  end
  let(:flags) { nil }
  let(:major_version_number) { 3 }

  let(:element_id) { "chp0" }
  let(:separator) { "\x00" }
  let(:start_time) { 0 }
  let(:end_time) { 1000 }
  let(:start_offset) { 4294967295 }
  let(:end_offset) { 4294967295 }

  let(:raw_subframe_content) {
    encoding = "\x03"
    text = "Intro"
    encoding + text + separator
  }
  let(:raw_subframe_flags) { "\x00\x00" }
  let(:raw_subframe) {
    size = [raw_subframe_content.size].pack("N")
    "TIT2" + size + raw_subframe_flags + raw_subframe_content
  }

  let(:frame) { described_class.new(id, raw_content, flags, major_version_number) }

  describe "#id" do
    subject { frame.id }
    it { is_expected.to eq(:CHAP) }
  end

  describe "#element_id" do
    subject { frame.element_id }
    it { is_expected.to eq("chp0") }
  end

  describe "#start_time" do
    subject { frame.start_time }
    it { is_expected.to eq(0) }
  end

  describe "#end_time" do
    subject { frame.end_time }
    it { is_expected.to eq(1000) }
  end

  describe "#start_offset" do
    subject { frame.start_offset }
    it { is_expected.to eq(4294967295) }
  end

  describe "#end_offset" do
    subject { frame.end_offset }
    it { is_expected.to eq(4294967295) }
  end

  describe "#subframes" do
    subject { frame.subframes }
    it { is_expected.to be_an(Array) }

    it "parses subsequent frames" do
      expect(ID3Tag::Frames::V2::TextFrame).to receive(:new).with("TIT2", raw_subframe_content, raw_subframe_flags, major_version_number)
      subject
    end
  end

  describe "#inspectable_content" do
    subject { frame.inspectable_content }
    it { is_expected.to eq("chp0") }
  end

  describe "#inspect" do
    subject { frame.inspect }
    it { is_expected.to eq("<ID3Tag::Frames::V2::ChapterFrame CHAP: chp0>") }
  end
end
