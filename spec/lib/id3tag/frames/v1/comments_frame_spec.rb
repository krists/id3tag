require 'spec_helper'
describe ID3Tag::Frames::V1::CommentsFrame do
  describe '#id' do
    subject { described_class.new('comments', nil).id }
    it { should == 'comments' }
  end

  describe '#content' do
    context 'when comment is present' do
      subject { described_class.new('comments', 'some comment about the song').content }
      it { should == 'some comment about the song' }
    end

    context 'when comment is not present' do
      subject { described_class.new('comments', '').content }
      it { should == '' }
    end
  end

  describe '#language' do
    it 'should be unknown' do
      described_class.new('comments', '').language.should eq('unknown')
    end
  end

  describe '#desciption' do
    it 'should be unknown' do
      described_class.new('comments', '').desciption.should eq('unknown')
    end
  end
end
