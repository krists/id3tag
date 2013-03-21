# encoding: utf-8
require 'spec_helper'

describe ID3Tag::Frames::V2::UniqueFileIdFrame do
  let(:id) { "UFID" }
  let(:raw_content) { "ZXC\x00foobar" }
  let(:flags) { nil }
  let(:major_version_number) { 4 }
  let(:frame) { described_class.new(id, raw_content, flags, major_version_number) }

  describe '#id' do
    subject { frame.id }
    it { should == :UFID }
  end

  describe '#owner_identifier' do
    subject { frame.owner_identifier }
    it { should == 'ZXC' }
  end

  describe '#content' do
    subject { frame.content }
    it { should == 'foobar' }
  end

  describe '#inspect' do
    it 'should be pretty inspectable' do
      frame.inspect.should eq('<ID3Tag::Frames::V2::UniqueFileIdFrame UFID: ZXC>')
    end
  end
end
