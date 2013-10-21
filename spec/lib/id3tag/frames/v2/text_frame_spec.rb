# encoding: utf-8
require 'spec_helper'

describe ID3Tag::Frames::V2::TextFrame do
  let(:id) { "artist" }
  let(:raw_content) { text.encode(target_encoding.to_s).prepend(encoding_byte.force_encoding(target_encoding)) }
  let(:flags) { nil }
  let(:major_version_number) { 4 }

  let(:frame) { described_class.new(id, raw_content, flags, major_version_number) }
  let(:target_encoding) { Encoding::UTF_8 }
  let(:encoding_byte) { "\x03" }
  let(:text) { "Glāzšķūņrūķīši" }

  describe '#id' do
    subject { frame.id }
    it { should == :artist }
  end

  describe '#content' do
    subject { frame.content }

    context "when text's last char is null byte" do
      let(:target_encoding) { Encoding::UTF_8 }
      let(:encoding_byte) { "\x03" }
      let(:text) { "Glāzšķūņrūķīši\x00" }
      it { should == 'Glāzšķūņrūķīši' }
    end

    context "when encoding byte is not present" do
      let(:encoding_byte) { "" }
      it { expect { subject }.to raise_error(ID3Tag::Frames::V2::TextFrame::UnsupportedTextEncoding) }
    end

    context "when encoding is ISO08859_1" do
      let(:target_encoding) { Encoding::ISO8859_1 }
      let(:encoding_byte) { "\x00" }
      let(:text) { "some fancy artist" }
      it { should == 'some fancy artist' }
    end

    context "when encoding is UTF_16" do
      let(:target_encoding) { Encoding::UTF_16 }
      let(:encoding_byte) { "\x01" }
      it { should == 'Glāzšķūņrūķīši' }
    end

    context "when encoding is UTF_16BE" do
      let(:target_encoding) { Encoding::UTF_16BE }
      let(:encoding_byte) { "\x02" }
      it { should == 'Glāzšķūņrūķīši' }
    end

    context "when encoding is UTF_8" do
      let(:target_encoding) { Encoding::UTF_8 }
      let(:encoding_byte) { "\x03" }
      it { should == 'Glāzšķūņrūķīši' }
    end

    context "when UTF-16 and missing BOM" do
      let(:target_encoding) { Encoding::UTF_8 }
      let(:raw_content) { "\x01a\x00b\x00c\x00" }
      it "raises error Encoding::InvalidByteSequenceError" do
        expect { subject }.to raise_error(Encoding::InvalidByteSequenceError)
      end
      context "when using global encode options" do
        before(:each) do
          ID3Tag.configuration do |c|
            c.string_encode_options = { :invalid => :replace, :undef => :replace, :replace => "R" }
          end
        end
        after(:each) do
          ID3Tag.configuration do |c|
            c.string_encode_options = {}
            c.string_source_encoding = nil
          end
        end
        it "does not raise error" do
          expect { subject }.not_to raise_error
          should == "RRR"
        end
      end

      context "when using global source encoding" do
        before(:each) do
          ID3Tag.configuration do |c|
            c.string_source_encoding = Encoding::UTF_16LE
          end
        end
        after(:each) do
          ID3Tag.configuration do |c|
            c.string_encode_options = {}
            c.string_source_encoding = nil
          end
        end
        it "does not raise error" do
          expect { subject }.not_to raise_error
          should == "abc"
        end
      end
    end
  end

  describe '#inspect' do
    it 'should be pretty inspectable' do
      frame.inspect.should eq('<ID3Tag::Frames::V2::TextFrame artist: Glāzšķūņrūķīši>')
    end
  end
end
