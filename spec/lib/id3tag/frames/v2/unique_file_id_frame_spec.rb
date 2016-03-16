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
    it { is_expected.to eq(:UFID) }
  end

  describe '#owner_identifier' do
    subject { frame.owner_identifier }
    it { is_expected.to eq('ZXC') }
  end

  describe '#content' do
    subject { frame.content }
    it { is_expected.to eq('foobar') }
  end

  describe '#inspect' do
    it 'should be pretty inspectable' do
      expect(frame.inspect).to eq('<ID3Tag::Frames::V2::UniqueFileIdFrame UFID: ZXC>')
    end
  end
end
