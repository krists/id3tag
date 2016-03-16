require 'spec_helper'

describe ID3Tag::Frames::V2::BasicFrame do
  let(:id) { 'foo' }
  let(:raw_content) { 'bar' }
  let(:flags) { nil }
  let(:major_version_number) { 4 }
  let(:frame) { described_class.new(id, raw_content, flags, major_version_number) }

  describe '#id' do
    subject { frame.id }
    it { is_expected.to eq(:foo) }
  end

  describe '#content' do
    subject { frame.content }
    it { is_expected.to eq('bar') }
    context "when frame contains unsynchronised content" do
      subject { frame }
      let(:flags) { [0b00000000, 0b00000010].pack("C2") }
      let(:raw_content) { "\xFF\x00\xEE\xEE" }

      describe '#content' do
        subject { super().content }
        it { is_expected.to eq("\xFF\xEE\xEE") }
      end
    end
  end

  describe '#final_size' do
    subject { frame }
    context "when all frags nulled" do
      let(:raw_content) { 'foo' }
      let(:flags) { nil }

      describe '#final_size' do
        subject { super().final_size }
        it { is_expected.to eq 3 }
      end
    end
    context "when frame is compressed and data length is set" do
      let(:flags) { [0b00000000, 0b00001001].pack("C2") }
      let(:raw_content) { [55].pack("N") + 'foo' }

      describe '#final_size' do
        subject { super().final_size }
        it { is_expected.to eq 55 }
      end

      describe '#content' do
        subject { super().content }
        it { is_expected.to eq "foo" }
      end
    end
  end

  describe '#group_id' do
    subject { frame }
    context "when all frags nulled" do
      let(:raw_content) { 'foo' }
      let(:flags) { nil }

      describe '#group_id' do
        subject { super().group_id }
        it { is_expected.to eq nil }
      end
    end
    context "when frame is compressed and data length is set" do
      let(:flags) { [0b00000000, 0b01000000].pack("C2") }
      let(:raw_content) { [33].pack("C") + 'foo' }

      describe '#content' do
        subject { super().content }
        it { is_expected.to eq "foo" }
      end

      describe '#group_id' do
        subject { super().group_id }
        it { is_expected.to eq 33 }
      end
    end
  end

  describe '#encryption_id' do
    subject { frame }
    context "when all frags nulled" do
      let(:raw_content) { 'foo' }
      let(:flags) { nil }

      describe '#encryption_id' do
        subject { super().encryption_id }
        it { is_expected.to eq nil }
      end
    end
    context "when frame is compressed and data length is set" do
      let(:flags) { [0b00000000, 0b00000100].pack("C2") }
      let(:raw_content) { [1].pack("C") + 'foo' }

      describe '#content' do
        subject { super().content }
        it { is_expected.to eq "foo" }
      end

      describe '#encryption_id' do
        subject { super().encryption_id }
        it { is_expected.to eq 1 }
      end
    end
  end

  describe "frame future query methods" do
    subject { frame }
    describe "#read_only?" do
      it "should delegate to FrameFlags class" do
        expect_any_instance_of(ID3Tag::Frames::V2::FrameFlags).to receive(:read_only?)
        subject.read_only?
      end
    end

    describe "#preserve_on_tag_alteration?" do
      it "should delegate to FrameFlags class" do
        expect_any_instance_of(ID3Tag::Frames::V2::FrameFlags).to receive(:preserve_on_tag_alteration?)
        subject.preserve_on_tag_alteration?
      end
    end

    describe "#preserve_on_file_alteration?" do
      it "should delegate to FrameFlags class" do
        expect_any_instance_of(ID3Tag::Frames::V2::FrameFlags).to receive(:preserve_on_file_alteration?)
        subject.preserve_on_file_alteration?
      end
    end
  end

  describe '#inspect' do
    it 'should be pretty inspectable' do
      expect(frame.inspect).to eq('<ID3Tag::Frames::V2::BasicFrame foo>')
    end
  end
end
