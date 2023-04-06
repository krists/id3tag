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
      [end_offset].pack("N")
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

  let(:text) { "Intro" }
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
    it { is_expected.to eq([]) }
  end
end
