require 'spec_helper'

describe ID3Tag::Frames::V2::BasicFrame do
  let(:id) { 'foo' }
  let(:raw_content) { 'bar' }
  let(:flags) { nil }
  let(:major_version_number) { 4 }
  let(:frame) { described_class.new(id, raw_content, flags, major_version_number) }

  describe '#id' do
    subject { frame.id }
    it { should == :foo }
  end

  describe '#content' do
    subject { frame.content }
    it { should == 'bar' }
  end

  describe '#inspect' do
    it 'should be pretty inspectable' do
      frame.inspect.should eq('<ID3Tag::Frames::V2::BasicFrame foo: bar>')
    end
  end
end
