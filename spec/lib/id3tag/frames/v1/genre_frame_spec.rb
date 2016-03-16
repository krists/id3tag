require 'spec_helper'
describe ID3Tag::Frames::V1::GenreFrame do
  describe '#id' do
    subject { described_class.new('genre', nil).id }
    it { is_expected.to eq('genre') }
  end

  describe '#content' do
    context 'when genre is blues' do
      subject { described_class.new('genre', [0].pack('c')).content }
      it { is_expected.to eq('Blues') }
    end

    context 'when genre is metal' do
      subject { described_class.new('genre', [9].pack('c')).content }
      it { is_expected.to eq('Metal') }
    end
  end
end

