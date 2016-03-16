require 'spec_helper'
describe ID3Tag::Frames::V1::TrackNrFrame do
  describe '#id' do
    subject { described_class.new('track_nr', nil).id }
    it { is_expected.to eq('track_nr') }
  end

  describe '#content' do
    context 'when nr is 3' do
      subject { described_class.new('track_nr', [3].pack('c')).content }
      it { is_expected.to eq('3') }
    end

    context 'when nr is 11' do
      subject { described_class.new('track_nr', [11].pack('c')).content }
      it { is_expected.to eq('11') }
    end
  end
end
