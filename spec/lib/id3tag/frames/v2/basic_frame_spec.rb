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
    context "when frame contains unsynchronised content" do
      subject { frame }
      let(:flags) { [0b00000000, 0b00000010].pack("C2") }
      let(:raw_content) { "\xFF\x00\xEE\xEE" }
      its(:content) { should eq("\xFF\xEE\xEE") }
    end
  end

  describe '#final_size' do
    subject { frame }
    context "when all frags nulled" do
      let(:raw_content) { 'foo' }
      let(:flags) { nil }
      its(:final_size) { should eq 3 }
    end
    context "when frame is compressed and data length is set" do
      let(:flags) { [0b00000000, 0b00001001].pack("C2") }
      let(:raw_content) { [55].pack("N") + 'foo' }
      its(:final_size) { should eq 55 }
      its(:content) { should eq "foo" }
    end
  end

  describe '#group_id' do
    subject { frame }
    context "when all frags nulled" do
      let(:raw_content) { 'foo' }
      let(:flags) { nil }
      its(:group_id) { should eq nil }
    end
    context "when frame is compressed and data length is set" do
      let(:flags) { [0b00000000, 0b01000000].pack("C2") }
      let(:raw_content) { [33].pack("C") + 'foo' }
      its(:content) { should eq "foo" }
      its(:group_id) { should eq 33 }
    end
  end

  describe '#encryption_id' do
    subject { frame }
    context "when all frags nulled" do
      let(:raw_content) { 'foo' }
      let(:flags) { nil }
      its(:encryption_id) { should eq nil }
    end
    context "when frame is compressed and data length is set" do
      let(:flags) { [0b00000000, 0b00000100].pack("C2") }
      let(:raw_content) { [1].pack("C") + 'foo' }
      its(:content) { should eq "foo" }
      its(:encryption_id) { should eq 1 }
    end
  end

  describe "frame future query methods" do
    subject { frame }
    describe "#read_only?" do
      it "should delegate to FrameFlags class" do
        ID3Tag::Frames::V2::FrameFlags.any_instance.should_receive(:read_only?)
        subject.read_only?
      end
    end

    describe "#preserve_on_tag_alteration?" do
      it "should delegate to FrameFlags class" do
        ID3Tag::Frames::V2::FrameFlags.any_instance.should_receive(:preserve_on_tag_alteration?)
        subject.preserve_on_tag_alteration?
      end
    end

    describe "#preserve_on_file_alteration?" do
      it "should delegate to FrameFlags class" do
        ID3Tag::Frames::V2::FrameFlags.any_instance.should_receive(:preserve_on_file_alteration?)
        subject.preserve_on_file_alteration?
      end
    end
  end

  describe '#inspect' do
    it 'should be pretty inspectable' do
      frame.inspect.should eq('<ID3Tag::Frames::V2::BasicFrame foo: bar>')
    end
  end
end
