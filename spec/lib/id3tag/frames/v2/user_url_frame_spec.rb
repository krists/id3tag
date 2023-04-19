require "spec_helper"

describe ID3Tag::Frames::V2::UserUrlFrame do
  let(:id) { "WXXX" }
  let(:raw_content) { encoding_byte + description + separator + url }

  let(:encoding_byte) { "\x03" }
  let(:description) { "Description" }
  let(:url) { "http://example.com" }
  let(:separator) { "\x00" }

  let(:flags) { nil }
  let(:major_version_number) { 3 }

  let(:frame) { described_class.new(id, raw_content, flags, major_version_number) }

  describe "#id" do
    subject { frame.id }
    it { is_expected.to eq(:WXXX) }
  end

  describe "#description" do
    subject { frame.description }
    it { is_expected.to eq("Description") }
  end

  describe "#url" do
    subject { frame.url }
    it { is_expected.to eq("http://example.com") }
  end

  describe "#content" do
    subject { frame.content }
    it { is_expected.to eq("http://example.com") }
  end

  describe "#inspectable_content" do
    subject { frame.inspectable_content }
    it { is_expected.to eq("http://example.com") }
  end

  describe "#inspect" do
    subject { frame.inspect }
    it { is_expected.to eq("<ID3Tag::Frames::V2::UserUrlFrame WXXX: http://example.com>") }
  end
end
