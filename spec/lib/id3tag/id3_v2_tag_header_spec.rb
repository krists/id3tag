require "spec_helper"

describe ID3Tag::ID3v2TagHeader do
  subject { described_class.new(header_data) }
  
  describe "#major_version_number" do
    context "when first bit represent 3" do
      let(:header_data) { "ID3\03\00..." }

      describe '#major_version_number' do
        subject { super().major_version_number }
        it { is_expected.to eq(3) }
      end
    end
  end

  describe "#minor_version_number" do
    context "when 2nd bit represent 2" do
      let(:header_data) { "ID3\03\02..." }

      describe '#minor_version_number' do
        subject { super().minor_version_number }
        it { is_expected.to eq(2) }
      end
    end
  end

  describe "#version_number" do
    let(:header_data) { "ID3\02\03..." }

    describe '#version_number' do
      subject { super().version_number }
      it { is_expected.to eq("2.3") }
    end
  end

  describe "header flags" do
    context "when flags bite is 0b10000000" do
      let(:header_data) { "ID3\03\00#{0b10000000.chr}" }

      describe '#unsynchronisation?' do
        subject { super().unsynchronisation? }
        it { is_expected.to eq(true) }
      end

      describe '#extended_header?' do
        subject { super().extended_header? }
        it { is_expected.to eq(false) }
      end

      describe '#experimental?' do
        subject { super().experimental? }
        it { is_expected.to eq(false) }
      end

      describe '#footer_present?' do
        subject { super().footer_present? }
        it { is_expected.to eq(false) }
      end
    end
    context "when flags bite is 0b01000000" do
      let(:header_data) { "ID3\03\00#{0b01000000.chr}" }

      describe '#unsynchronisation?' do
        subject { super().unsynchronisation? }
        it { is_expected.to eq(false) }
      end

      describe '#extended_header?' do
        subject { super().extended_header? }
        it { is_expected.to eq(true) }
      end

      describe '#experimental?' do
        subject { super().experimental? }
        it { is_expected.to eq(false) }
      end

      describe '#footer_present?' do
        subject { super().footer_present? }
        it { is_expected.to eq(false) }
      end
    end
    context "when flags bite is 0b00100000" do
      let(:header_data) { "ID3\03\00#{0b00100000.chr}" }

      describe '#unsynchronisation?' do
        subject { super().unsynchronisation? }
        it { is_expected.to eq(false) }
      end

      describe '#extended_header?' do
        subject { super().extended_header? }
        it { is_expected.to eq(false) }
      end

      describe '#experimental?' do
        subject { super().experimental? }
        it { is_expected.to eq(true) }
      end

      describe '#footer_present?' do
        subject { super().footer_present? }
        it { is_expected.to eq(false) }
      end
    end
    context "when flags bite is 0b00010000" do
      let(:header_data) { "ID3\03\00#{0b00010000.chr}" }

      describe '#unsynchronisation?' do
        subject { super().unsynchronisation? }
        it { is_expected.to eq(false) }
      end

      describe '#extended_header?' do
        subject { super().extended_header? }
        it { is_expected.to eq(false) }
      end

      describe '#experimental?' do
        subject { super().experimental? }
        it { is_expected.to eq(false) }
      end

      describe '#footer_present?' do
        subject { super().footer_present? }
        it { is_expected.to eq(true) }
      end
    end
  end

  describe "#tag_size" do
    let(:header_data) { "ID3abc\x00\x00\x01\x7F" }

    describe '#tag_size' do
      subject { super().tag_size }
      it { is_expected.to eq(255) }
    end
  end

  describe "#inspect" do
    let(:header_data) { "ID3\u0003\u0000\u0000\u0000\u0000\u0000\u0000" }

    describe '#inspect' do
      subject { super().inspect }
      it { is_expected.to eq "<ID3Tag::ID3v2TagHeader version:2.3.0 size:0 unsync:false ext.header:false experimental:false footer:false>" }
    end
  end
end
