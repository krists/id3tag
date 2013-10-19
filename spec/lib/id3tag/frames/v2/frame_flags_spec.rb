require 'spec_helper'

describe ID3Tag::Frames::V2::FrameFlags do
  subject { described_class.new(flag_bytes, version) }

  context "When major version is 2" do
    let(:flag_bytes) { nil }
    let(:version) { 2 }

    its(:preserve_on_tag_alteration?) { should be_true }
    its(:preserve_on_file_alteration?) { should be_true }
    its(:read_only?) { should be_false }
    its(:compressed?) { should be_false }
    its(:encrypted?) { should be_false }
    its(:grouped?) { should be_false }
    its(:unsynchronised?) { should be_false }
    its(:data_length_indicator?) { should be_false }
    its(:additional_info_byte_count) { should eq 0 }
    its(:position_and_count_of_data_length_bytes) { should eq nil }
    its(:position_and_count_of_group_id_bytes) { should eq nil }
    its(:position_and_count_of_encryption_id_bytes) { should eq nil }
  end

  context "when major version is 3" do
    let(:version) { 3 }
    context "when all flags are nulled" do
      let(:flag_bytes) { [0b00000000, 0b00000000].pack("C2") }
      its(:preserve_on_tag_alteration?) { should be_true }
      its(:preserve_on_file_alteration?) { should be_true }
      its(:read_only?) { should be_false }
      its(:compressed?) { should be_false }
      its(:encrypted?) { should be_false }
      its(:grouped?) { should be_false }
      its(:unsynchronised?) { should be_false }
      its(:data_length_indicator?) { should be_false }
      its(:additional_info_byte_count) { should eq 0 }
      its(:position_and_count_of_data_length_bytes) { should eq nil }
      its(:position_and_count_of_group_id_bytes) { should eq nil }
      its(:position_and_count_of_encryption_id_bytes) { should eq nil }
    end

    context "when compression is on" do
      let(:flag_bytes) { [0b00000000, 0b10000000].pack("C2") }
      its(:preserve_on_tag_alteration?) { should be_true }
      its(:preserve_on_file_alteration?) { should be_true }
      its(:read_only?) { should be_false }
      its(:compressed?) { should be_true }
      its(:encrypted?) { should be_false }
      its(:grouped?) { should be_false }
      its(:unsynchronised?) { should be_false }
      its(:data_length_indicator?) { should be_false }
      its(:additional_info_byte_count) { should eq 4 }
      its(:position_and_count_of_data_length_bytes) { should eq [0, 4] }
      its(:position_and_count_of_group_id_bytes) { should eq nil }
      its(:position_and_count_of_encryption_id_bytes) { should eq nil }
    end

    context "when compression and group id is on" do
      let(:flag_bytes) { [0b00000000, 0b10100000].pack("C2") }
      its(:preserve_on_tag_alteration?) { should be_true }
      its(:preserve_on_file_alteration?) { should be_true }
      its(:read_only?) { should be_false }
      its(:compressed?) { should be_true }
      its(:encrypted?) { should be_false }
      its(:grouped?) { should be_true }
      its(:unsynchronised?) { should be_false }
      its(:data_length_indicator?) { should be_false }
      its(:additional_info_byte_count) { should eq 5 }
      its(:position_and_count_of_data_length_bytes) { should eq [0, 4] }
      its(:position_and_count_of_group_id_bytes) { should eq [4, 1] }
      its(:position_and_count_of_encryption_id_bytes) { should eq nil }
    end

    context "when all flags are 1" do
      let(:flag_bytes) { [0b11100000, 0b11100000].pack("C2") }
      its(:preserve_on_tag_alteration?) { should be_false }
      its(:preserve_on_file_alteration?) { should be_false }
      its(:read_only?) { should be_true }
      its(:compressed?) { should be_true }
      its(:encrypted?) { should be_true }
      its(:grouped?) { should be_true }
      its(:unsynchronised?) { should be_false }
      its(:data_length_indicator?) { should be_false }
      its(:additional_info_byte_count) { should eq 6 }
      its(:position_and_count_of_data_length_bytes) { should eq [0, 4] }
      its(:position_and_count_of_group_id_bytes) { should eq [5, 1] }
      its(:position_and_count_of_encryption_id_bytes) { should eq [4, 1] }
    end
  end

  context "when major version is 4" do
    let(:version) { 4 }
    context "when all flags are nulled" do
      let(:flag_bytes) { [0b00000000, 0b00000000].pack("C2") }
      its(:preserve_on_tag_alteration?) { should be_true }
      its(:preserve_on_file_alteration?) { should be_true }
      its(:read_only?) { should be_false }
      its(:compressed?) { should be_false }
      its(:encrypted?) { should be_false }
      its(:grouped?) { should be_false }
      its(:unsynchronised?) { should be_false }
      its(:data_length_indicator?) { should be_false }
      its(:additional_info_byte_count) { should eq 0 }
      its(:position_and_count_of_data_length_bytes) { should eq nil }
      its(:position_and_count_of_group_id_bytes) { should eq nil }
      its(:position_and_count_of_encryption_id_bytes) { should eq nil }
    end

    context "when compression is on" do
      let(:flag_bytes) { [0b00000000, 0b10001001].pack("C2") }
      its(:preserve_on_tag_alteration?) { should be_true }
      its(:preserve_on_file_alteration?) { should be_true }
      its(:read_only?) { should be_false }
      its(:compressed?) { should be_true }
      its(:encrypted?) { should be_false }
      its(:grouped?) { should be_false }
      its(:unsynchronised?) { should be_false }
      its(:data_length_indicator?) { should be_true }
      its(:additional_info_byte_count) { should eq 4 }
      its(:position_and_count_of_data_length_bytes) { should eq [0, 4] }
      its(:position_and_count_of_group_id_bytes) { should eq nil }
      its(:position_and_count_of_encryption_id_bytes) { should eq nil }
    end

    context "when compression and group id is on" do
      let(:flag_bytes) { [0b00000000, 0b01001001].pack("C2") }
      its(:preserve_on_tag_alteration?) { should be_true }
      its(:preserve_on_file_alteration?) { should be_true }
      its(:read_only?) { should be_false }
      its(:compressed?) { should be_true }
      its(:encrypted?) { should be_false }
      its(:grouped?) { should be_true }
      its(:unsynchronised?) { should be_false }
      its(:data_length_indicator?) { should be_true }
      its(:additional_info_byte_count) { should eq 5 }
      its(:position_and_count_of_data_length_bytes) { should eq [1, 4] }
      its(:position_and_count_of_group_id_bytes) { should eq [0, 1] }
      its(:position_and_count_of_encryption_id_bytes) { should eq nil }
    end

    context "when all flags are 1" do
      let(:flag_bytes) { [0b01110000, 0b01001111].pack("C2") }
      its(:preserve_on_tag_alteration?) { should be_false }
      its(:preserve_on_file_alteration?) { should be_false }
      its(:read_only?) { should be_true }
      its(:compressed?) { should be_true }
      its(:encrypted?) { should be_true }
      its(:grouped?) { should be_true }
      its(:unsynchronised?) { should be_true }
      its(:data_length_indicator?) { should be_true }
      its(:additional_info_byte_count) { should eq 6 }
      its(:position_and_count_of_data_length_bytes) { should eq [2, 4] }
      its(:position_and_count_of_group_id_bytes) { should eq [0, 1] }
      its(:position_and_count_of_encryption_id_bytes) { should eq [1, 1] }
    end
  end
end
