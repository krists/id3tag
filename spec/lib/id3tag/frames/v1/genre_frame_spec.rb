require 'spec_helper'
describe ID3Tag::Frames::V1::GenreFrame do
  FORMAT_FOR_8_BIT_SIGNED_INTEGER = 'c'
  describe '#id' do
    subject { described_class.new('genre', nil).id }
    it { should == 'genre' }
  end

  describe '#content' do
    context 'when genre is blues' do
      subject { described_class.new('genre', [0].pack(FORMAT_FOR_8_BIT_SIGNED_INTEGER)).content }
      it { should == 'Blues' }
    end

    context 'when genre is metal' do
      subject { described_class.new('genre', [9].pack(FORMAT_FOR_8_BIT_SIGNED_INTEGER)).content }
      it { should == 'Metal' }
    end
  end
end

