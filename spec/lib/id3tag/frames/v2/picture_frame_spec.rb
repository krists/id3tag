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
      it { should == :PIC }
    end

    describe "mime_type" do
      subject { frame.mime_type }
      it { should eq('image/png') }
      context "when mime type is blank" do
        let(:format) { "\x00\x00\x00" }
        it { should eq('image/') }
      end
    end

    describe "#data" do
      subject { frame.data }
      it { should == "picture data" }
    end

    describe "#type" do
      subject { frame.type }
      it { should == :cover_front }
    end

    describe "#description" do
      subject { frame.description }
      it { should == "picture description" }
    end

    describe "#content" do
      subject { frame.content }
      it { should == "picture data" }
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
      it { should == :APIC }
    end

    describe "#data" do
      subject { frame.data }
      it { should == "picture data" }
    end

    describe "#type" do
      subject { frame.type }
      it { should == :cover_front }
    end

    describe "#mime_type" do
      subject { frame.mime_type }
      it { should == "image/png" }
      context "when mime type is omitted" do
        let(:mime_type) { "\x00" }
        subject { frame.mime_type }
        it { should == "image/" }
      end
    end

    describe "#description" do
      subject { frame.description }
      it { should == "picture description" }
    end

    describe "#content" do
      subject { frame.content }
      it { should == "picture data" }
    end

    context "when frame contains link not actual image data" do
      let(:raw_content) { "\x02-->\x00\x08\u0000a\u0000b\u0000c" }
      subject { frame }

      its(:link?) { should be_true }
      its(:mime_type) { should eq("-->") }
      its(:description) { should eq("abc") }
      its(:type) { should eq(:artist) }
    end
  end
end
