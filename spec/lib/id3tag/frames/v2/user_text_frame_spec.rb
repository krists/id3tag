# encoding: utf-8
require 'spec_helper'

describe ID3Tag::Frames::V2::UserTextFrame do
  let(:id) { "TXX" }
  let(:raw_content) { text.encode(target_encoding).prepend(encoding_byte.force_encoding(target_encoding)) }
  let(:flags) { nil }
  let(:major_version_number) { 4 }

  let(:target_encoding) { Encoding::UTF_8 }
  let(:encoding_byte) { "\x03" }
  let(:text) { "SUPER_FRAME\x00Glāzšķūņrūķīši" }
  subject { described_class.new(id, raw_content, flags, major_version_number) }

  describe '#id' do
    subject { super().id }
    it { is_expected.to eq(:TXX) }
  end

  describe '#content' do
    subject { super().content }
    it { is_expected.to eq('Glāzšķūņrūķīši') }
  end

  describe '#description' do
    subject { super().description }
    it { is_expected.to eq('SUPER_FRAME') }
  end

  describe '#inspect' do
    subject { super().inspect }
    it { is_expected.to eq('<ID3Tag::Frames::V2::UserTextFrame TXX: Glāzšķūņrūķīši>') }
  end
end
