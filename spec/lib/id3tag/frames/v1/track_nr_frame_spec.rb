require 'spec_helper'
describe ID3Tag::Frames::V1::TrackNrFrame do
  FORMAT_FOR_8_BIT_SIGNED_INTEGER = 'c'
  describe '#id' do
    subject { described_class.new('track_nr', nil).id }
    it { should == 'track_nr' }
  end

  describe '#content' do
    context 'when nr is 3' do
      subject { described_class.new('track_nr', [3].pack(FORMAT_FOR_8_BIT_SIGNED_INTEGER)).content }
      it { should == '3' }
    end

    context 'when nr is 11' do
      subject { described_class.new('track_nr', [11].pack(FORMAT_FOR_8_BIT_SIGNED_INTEGER)).content }
      it { should == '11' }
    end
  end
end
