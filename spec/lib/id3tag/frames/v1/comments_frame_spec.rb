require 'spec_helper'
describe ID3Tag::Frames::V1::CommentsFrame do
  describe '#id' do
    subject { described_class.new('comments', nil).id }
    it { is_expected.to eq('comments') }
  end

  describe '#content' do
    context 'when comment is present' do
      subject { described_class.new('comments', 'some comment about the song').content }
      it { is_expected.to eq('some comment about the song') }
    end

    context 'when comment is not present' do
      subject { described_class.new('comments', '').content }
      it { is_expected.to eq('') }
    end
  end

  describe "#text" do
    subject { described_class.new('comments', 'some comment about the song') }
    it "should be the same as #content" do
      allow(subject).to receive(:content) { "ZXC" }
      expect(subject.text).to eq(subject.content)
    end
  end

  describe '#language' do
    it 'should be unknown' do
      expect(described_class.new('comments', '').language).to eq('unknown')
    end
  end

  describe '#desciption' do
    it 'should be unknown' do
      expect(described_class.new('comments', '').desciption).to eq('unknown')
    end
  end
end
