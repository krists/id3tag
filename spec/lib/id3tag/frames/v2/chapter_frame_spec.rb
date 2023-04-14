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
      raw_text_subframe,
      raw_url_subframe,
      raw_picture_subframe
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

  let(:raw_text_subframe_content) {
    encoding = "\x03"
    text = "Intro"
    encoding + text
  }
  let(:raw_text_subframe_flags) { "\x00\x00" }
  let(:raw_text_subframe) {
    size = [raw_text_subframe_content.size].pack("N")
    "TIT2" + size + raw_text_subframe_flags + raw_text_subframe_content
  }

  let(:raw_url_subframe_content) {
    encoding = "\x00"
    description = "Description"
    url = "http://example.com"
    encoding + description + separator + url
  }
  let(:raw_url_subframe_flags) { "\x00\x00" }
  let(:raw_url_subframe) {
    size = [raw_url_subframe_content.size].pack("N")
    "WXXX" + size + raw_url_subframe_flags + raw_url_subframe_content
  }

  let(:raw_picture_subframe_content) {
    encoding = "\x03"
    format = "png"
    picture_type = "\x03"
    description = "picture description"
    data = "picture data"
    encoding + format + separator + picture_type + description + separator + data
  }
  let(:raw_picture_subframe_flags) { "\x00\x00" }
  let(:raw_picture_subframe) {
    size = [raw_picture_subframe_content.size].pack("N")
    "APIC" + size + raw_picture_subframe_flags + raw_picture_subframe_content
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
      expect(ID3Tag::Frames::V2::TextFrame).to receive(:new).with("TIT2", raw_text_subframe_content, raw_text_subframe_flags, major_version_number)
      expect(ID3Tag::Frames::V2::UserUrlFrame).to receive(:new).with("WXXX", raw_url_subframe_content, raw_url_subframe_flags, major_version_number)
      expect(ID3Tag::Frames::V2::PictureFrame).to receive(:new).with("APIC", raw_picture_subframe_content, raw_picture_subframe_flags, major_version_number)
      subject
    end
  end

  describe "#title" do
    subject { frame.title }
    it { is_expected.to eq("Intro") }
  end

  describe "#url" do
    subject { frame.url }
    it { is_expected.to eq("http://example.com") }
  end

  describe "#picture" do
    subject { frame.picture }
    it { is_expected.to eq("picture data") }
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
