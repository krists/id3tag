require 'spec_helper'
describe ID3Tag::Frames::V1::TextFrame do
  describe '#id' do
    subject { described_class.new('album', nil).id }
    it { is_expected.to eq('album') }
  end

  describe '#content' do
    context 'when containing track artist' do
      subject { described_class.new('artist', 'some fancy artist').content }
      it { is_expected.to eq('some fancy artist') }
    end
  end
end
