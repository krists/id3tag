# encoding: utf-8
require 'spec_helper'

describe ID3Tag::Frames::V2::CommentsFrame do
  let(:id) { "COMM" }
  let(:raw_content) do
    text.encode(target_encoding).prepend(separator).prepend(short_desc).prepend(lang).prepend(encoding)
  end
  let(:separator) { "\x00".force_encoding(target_encoding) }
  let(:short_desc) { 'bob once said'.force_encoding(target_encoding) }
  let(:lang) { 'lav'.force_encoding(target_encoding) }
  let(:encoding) { encoding_byte.force_encoding(target_encoding) }
  let(:flags) { nil }
  let(:major_version_number) { 4 }
  let(:target_encoding) { Encoding::UTF_8 }
  let(:encoding_byte) { "\x03" }
  let(:text) { "Glāzšķūņrūķīši" }
  let(:frame) { described_class.new(id, raw_content, flags, major_version_number) }

  describe '#id' do
    subject { frame.id }
    it { should == :COMM }
  end

  describe '#content' do
    subject { frame.content }
    it { should == 'Glāzšķūņrūķīši' }
  end

  describe '#language' do
    subject { frame.language }
    it { should == 'lav' }
  end

  describe '#description' do
    subject { frame.description }
    it { should == 'bob once said' }
  end

  describe '#inspect' do
    it 'should be pretty inspectable' do
      frame.inspect.should eq('<ID3Tag::Frames::V2::CommentsFrame COMM: Glāzšķūņrūķīši>')
    end
  end
end
