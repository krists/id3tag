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

  context 'when flags are not present. like in version v2.2' do
    subject { frame }
    let(:major_version_number) { 2 }

    its(:preserve_on_tag_alteration?) { should be_true }
    its(:preserve_on_file_alteration?) { should be_true }
    its(:read_only?) { should be_false }
    its(:compressed?) { should be_false }
    its(:encrypted?) { should be_false }
    its(:grouped?) { should be_false }
  end

  context "when using v.2.3" do
    let(:major_version_number) { 3 }
    context "when all frags set to 1" do
      let(:flags) { [0b11100000,0b11100000].pack("C2") }
      subject { frame }
      its(:preserve_on_tag_alteration?) { should be_false }
      its(:preserve_on_file_alteration?) { should be_false }
      its(:read_only?) { should be_true }
      its(:compressed?) { should be_true }
      its(:encrypted?) { should be_true }
      its(:grouped?) { should be_true }
    end

    context "when frags are mixed" do
      let(:flags) { [0b10100000,0b01000000].pack("C2") }
      subject { frame }
      its(:preserve_on_tag_alteration?) { should be_false }
      its(:preserve_on_file_alteration?) { should be_true }
      its(:read_only?) { should be_true }
      its(:compressed?) { should be_false }
      its(:encrypted?) { should be_true }
      its(:grouped?) { should be_false }
    end

    context "when frame is compressed" do
      let(:flags) { [0b00000000,0b10000000].pack("C2") }
      let(:raw_content) { [55].pack("N") + "aaaaa" }
      subject { frame }
      its(:decompressed_size) { should eq(55) }
    end

    context "when frame is not compressed" do
      let(:flags) { [0b00000000,0b00000000].pack("C2") }
      subject { frame }
      its(:decompressed_size) { should eq(3) }
    end

    context "when frame is grouped" do
      let(:flags) { [0b00000000,0b00100000].pack("C2") }
      let(:raw_content) { [77].pack("C") + "aaaaa" }
      subject { frame }
      its(:group_id) { should eq(77) }
      its(:content) { should eq("aaaaa") }
    end

    context "when frame is not grouped" do
      let(:flags) { [0b00000000,0b00000000].pack("C2") }
      let(:raw_content) { "z" }
      subject { frame }
      its(:group_id) { should eq(nil) }
      its(:content) { should eq("z") }
    end
  end

  context "when using v.2.4" do
    # TODO: write specs..
  end
end
