# encoding: utf-8
require 'spec_helper'

describe ID3Tag::Frames::V2::PictureFrame do
  let(:separator) { "\x00".force_encoding(target_encoding) }
  let(:encoding) { encoding_byte.force_encoding(target_encoding) }
  let(:flags) { nil }
  let(:target_encoding) { Encoding::UTF_8 }
  let(:encoding_byte) { "\x03" }
  let(:description) { "picture description" }
  let(:picture_type) { "\x03" } # cover_front
  let(:frame) { described_class.new(id, raw_content, flags, major_version_number) }
  let(:data) { "picture data" }

  context "when PIC frame" do
    let(:id) { "PIC" }
    let(:major_version_number) { 2 }
    let(:format) { "png" }
    let(:raw_content) do
      encoding_byte + format + picture_type + description + separator + data
    end

    describe '#id' do
      subject { frame.id }
      it { is_expected.to eq(:PIC) }
    end

    describe "mime_type" do
      subject { frame.mime_type }
      it { is_expected.to eq('image/png') }
      context "when mime type is blank" do
        let(:format) { "\x00\x00\x00" }
        it { is_expected.to eq('image/') }
      end
    end

    describe "#data" do
      subject { frame.data }
      it { is_expected.to eq("picture data") }
    end

    describe "#type" do
      subject { frame.type }
      it { is_expected.to eq(:cover_front) }
    end

    describe "#description" do
      subject { frame.description }
      it { is_expected.to eq("picture description") }
    end

    describe "#content" do
      subject { frame.content }
      it { is_expected.to eq("picture data") }
    end
  end

  context "when APIC frame" do
    let(:id) { "APIC" }
    let(:major_version_number) { 3 }
    let(:mime_type) { "image/png" }
    let(:raw_content) do
      # mime_type is iso 8859-1 so alawys terminated with \x00
      encoding_byte + mime_type + "\x00" + picture_type + description + separator + data
    end

    describe '#id' do
      subject { frame.id }
      it { is_expected.to eq(:APIC) }
    end

    describe "#data" do
      subject { frame.data }
      it { is_expected.to eq("picture data") }
    end

    describe "#type" do
      subject { frame.type }
      it { is_expected.to eq(:cover_front) }
    end

    describe "#mime_type" do
      subject { frame.mime_type }
      it { is_expected.to eq("image/png") }
      context "when mime type is omitted" do
        let(:mime_type) { "\x00" }
        subject { frame.mime_type }
        it { is_expected.to eq("image/") }
      end
    end

    describe "#description" do
      subject { frame.description }
      it { is_expected.to eq("picture description") }
    end

    describe "#content" do
      subject { frame.content }
      it { is_expected.to eq("picture data") }
    end

    context "when frame contains link not actual image data" do
      let(:raw_content) { "\x02-->\x00\x08\u0000a\u0000b\u0000c" }
      subject { frame }

      describe '#link?' do
        subject { super().link? }
        it { is_expected.to eq(true) }
      end

      describe '#mime_type' do
        subject { super().mime_type }
        it { is_expected.to eq("-->") }
      end

      describe '#description' do
        subject { super().description }
        it { is_expected.to eq("abc") }
      end

      describe '#type' do
        subject { super().type }
        it { is_expected.to eq(:artist) }
      end
    end
  end
end
