require "spec_helper"

describe ID3Tag::Frames::V2::TableOfContentsFrame do
  let(:id) { "CTOC" }
  let(:raw_content) do
    [
      element_id,
      separator,
      flags,
      [entry_count].pack("C"),
      *child_element_ids.map { |c| c + separator },
      raw_subframe
    ].join
  end
  let(:flags) { [top_level, ordered].join.to_i(2).to_s(16) }
  let(:major_version_number) { 3 }

  let(:element_id) { "toc" }
  let(:separator) { "\x00" }
  let(:top_level) { 1 }
  let(:ordered) { 1 }
  let(:entry_count) { 3 }
  let(:child_element_ids) { ["chp0", "chp1", "chp2"] }

  let(:raw_subframe_content) {
    encoding = "\x03"
    text = "Part 1"
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
    it { is_expected.to eq(:CTOC) }
  end

  describe "#element_id" do
    subject { frame.element_id }
    it { is_expected.to eq("toc") }
  end

  describe "#top_level?" do
    subject { frame.top_level? }
    it { is_expected.to eq(true) }
  end

  describe "#ordered?" do
    subject { frame.ordered? }
    it { is_expected.to eq(true) }
  end

  describe "#entry_count" do
    subject { frame.entry_count }
    it { is_expected.to eq(3) }
  end

  describe "#child_element_ids" do
    subject { frame.child_element_ids }
    it { is_expected.to eq(["chp0", "chp1", "chp2"]) }
  end

  describe "#subframes" do
    subject { frame.subframes }
    it "parses subsequent frames" do
      expect(ID3Tag::Frames::V2::TextFrame).to receive(:new).with("TIT2", raw_subframe_content, raw_subframe_flags, major_version_number)
      subject
    end
  end

  describe "#content" do
    subject { frame.content }
    it { is_expected.to eq(["chp0", "chp1", "chp2"]) }
  end

  describe "#inspectable_content" do
    subject { frame.content }
    it { is_expected.to eq(["chp0", "chp1", "chp2"]) }
  end

  describe "#inspect" do
    subject { frame.inspect }
    it { is_expected.to eq("<ID3Tag::Frames::V2::TableOfContentsFrame CTOC: [\"chp0\", \"chp1\", \"chp2\"]>") }
  end
end
