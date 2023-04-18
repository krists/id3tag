require "spec_helper"

describe ID3Tag::Frames::V2::UrlFrame do
  let(:id) { "W" }
  let(:raw_content) { url }
  let(:url) { "http://example.com" }

  let(:flags) { nil }
  let(:major_version_number) { 3 }

  let(:frame) { described_class.new(id, raw_content, flags, major_version_number) }

  describe "#id" do
    subject { frame.id }
    it { is_expected.to eq(id.to_sym) }
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
    it { is_expected.to eq("<ID3Tag::Frames::V2::UrlFrame #{id}: http://example.com>") }
  end

  context "with additional information after URL termination" do
    let(:raw_content) { url + "\x00additional info" }

    describe "#url" do
      subject { frame.url }
      it { is_expected.to eq("http://example.com") }
    end
  end
end
