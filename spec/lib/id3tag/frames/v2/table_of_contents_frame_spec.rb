require "spec_helper"

describe ID3Tag::Frames::V2::TableOfContentsFrame do
  let(:id) { "CTOC" }
  let(:raw_content) do
    [
      element_id,
      separator,
      flags,
      [entry_count].pack("C"),
      *child_element_ids.map { |c| c + separator }
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
end
