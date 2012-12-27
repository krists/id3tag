require "spec_helper"

describe ID3Tag::ID3v2TagHeader do
  subject { described_class.new(header_data) }
  
  describe "#major_version_number" do
    context "when first bit represent 3" do
      let(:header_data) { "ID3\03\00..." }
      its(:major_version_number) { should == 3 }
    end
  end

  describe "#minor_version_number" do
    context "when 2nd bit represent 2" do
      let(:header_data) { "ID3\03\02..." }
      its(:minor_version_number) { should == 2 }
    end
  end

  describe "header flags" do
    context "when flags bite is 0b10000000" do
      let(:header_data) { "ID3\03\00#{0b10000000.chr}" }
      its(:unsynchronisation?) { should be_true }
      its(:extended_header?) { should be_false }
      its(:experimental?) { should be_false }
      its(:footer_present?) { should be_false }
    end
    context "when flags bite is 0b01000000" do
      let(:header_data) { "ID3\03\00#{0b01000000.chr}" }
      its(:unsynchronisation?) { should be_false }
      its(:extended_header?) { should be_true }
      its(:experimental?) { should be_false }
      its(:footer_present?) { should be_false }
    end
    context "when flags bite is 0b00100000" do
      let(:header_data) { "ID3\03\00#{0b00100000.chr}" }
      its(:unsynchronisation?) { should be_false }
      its(:extended_header?) { should be_false }
      its(:experimental?) { should be_true }
      its(:footer_present?) { should be_false }
    end
    context "when flags bite is 0b00010000" do
      let(:header_data) { "ID3\03\00#{0b00010000.chr}" }
      its(:unsynchronisation?) { should be_false }
      its(:extended_header?) { should be_false }
      its(:experimental?) { should be_false }
      its(:footer_present?) { should be_true }
    end
  end

  describe "#tag_size" do
    let(:header_data) { "ID3abc\x00\x00\x01\x7F" }
    its(:tag_size) { should == 255 }
  end
end
