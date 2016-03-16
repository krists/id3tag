require 'spec_helper'

describe ID3Tag::Frames::V2::FrameFlags do
  subject { described_class.new(flag_bytes, version) }

  context "When major version is 2" do
    let(:flag_bytes) { nil }
    let(:version) { 2 }

    describe '#preserve_on_tag_alteration?' do
      subject { super().preserve_on_tag_alteration? }
      it { is_expected.to eq(true) }
    end

    describe '#preserve_on_file_alteration?' do
      subject { super().preserve_on_file_alteration? }
      it { is_expected.to eq(true) }
    end

    describe '#read_only?' do
      subject { super().read_only? }
      it { is_expected.to eq(false) }
    end

    describe '#compressed?' do
      subject { super().compressed? }
      it { is_expected.to eq(false) }
    end

    describe '#encrypted?' do
      subject { super().encrypted? }
      it { is_expected.to eq(false) }
    end

    describe '#grouped?' do
      subject { super().grouped? }
      it { is_expected.to eq(false) }
    end

    describe '#unsynchronised?' do
      subject { super().unsynchronised? }
      it { is_expected.to eq(false) }
    end

    describe '#data_length_indicator?' do
      subject { super().data_length_indicator? }
      it { is_expected.to eq(false) }
    end

    describe '#additional_info_byte_count' do
      subject { super().additional_info_byte_count }
      it { is_expected.to eq 0 }
    end

    describe '#position_and_count_of_data_length_bytes' do
      subject { super().position_and_count_of_data_length_bytes }
      it { is_expected.to eq nil }
    end

    describe '#position_and_count_of_group_id_bytes' do
      subject { super().position_and_count_of_group_id_bytes }
      it { is_expected.to eq nil }
    end

    describe '#position_and_count_of_encryption_id_bytes' do
      subject { super().position_and_count_of_encryption_id_bytes }
      it { is_expected.to eq nil }
    end
  end

  context "when major version is 3" do
    let(:version) { 3 }
    context "when all flags are nulled" do
      let(:flag_bytes) { [0b00000000, 0b00000000].pack("C2") }

      describe '#preserve_on_tag_alteration?' do
        subject { super().preserve_on_tag_alteration? }
        it { is_expected.to eq(true) }
      end

      describe '#preserve_on_file_alteration?' do
        subject { super().preserve_on_file_alteration? }
        it { is_expected.to eq(true) }
      end

      describe '#read_only?' do
        subject { super().read_only? }
        it { is_expected.to eq(false) }
      end

      describe '#compressed?' do
        subject { super().compressed? }
        it { is_expected.to eq(false) }
      end

      describe '#encrypted?' do
        subject { super().encrypted? }
        it { is_expected.to eq(false) }
      end

      describe '#grouped?' do
        subject { super().grouped? }
        it { is_expected.to eq(false) }
      end

      describe '#unsynchronised?' do
        subject { super().unsynchronised? }
        it { is_expected.to eq(false) }
      end

      describe '#data_length_indicator?' do
        subject { super().data_length_indicator? }
        it { is_expected.to eq(false) }
      end

      describe '#additional_info_byte_count' do
        subject { super().additional_info_byte_count }
        it { is_expected.to eq 0 }
      end

      describe '#position_and_count_of_data_length_bytes' do
        subject { super().position_and_count_of_data_length_bytes }
        it { is_expected.to eq nil }
      end

      describe '#position_and_count_of_group_id_bytes' do
        subject { super().position_and_count_of_group_id_bytes }
        it { is_expected.to eq nil }
      end

      describe '#position_and_count_of_encryption_id_bytes' do
        subject { super().position_and_count_of_encryption_id_bytes }
        it { is_expected.to eq nil }
      end
    end

    context "when compression is on" do
      let(:flag_bytes) { [0b00000000, 0b10000000].pack("C2") }

      describe '#preserve_on_tag_alteration?' do
        subject { super().preserve_on_tag_alteration? }
        it { is_expected.to eq(true) }
      end

      describe '#preserve_on_file_alteration?' do
        subject { super().preserve_on_file_alteration? }
        it { is_expected.to eq(true) }
      end

      describe '#read_only?' do
        subject { super().read_only? }
        it { is_expected.to eq(false) }
      end

      describe '#compressed?' do
        subject { super().compressed? }
        it { is_expected.to eq(true) }
      end

      describe '#encrypted?' do
        subject { super().encrypted? }
        it { is_expected.to eq(false) }
      end

      describe '#grouped?' do
        subject { super().grouped? }
        it { is_expected.to eq(false) }
      end

      describe '#unsynchronised?' do
        subject { super().unsynchronised? }
        it { is_expected.to eq(false) }
      end

      describe '#data_length_indicator?' do
        subject { super().data_length_indicator? }
        it { is_expected.to eq(false) }
      end

      describe '#additional_info_byte_count' do
        subject { super().additional_info_byte_count }
        it { is_expected.to eq 4 }
      end

      describe '#position_and_count_of_data_length_bytes' do
        subject { super().position_and_count_of_data_length_bytes }
        it { is_expected.to eq [0, 4] }
      end

      describe '#position_and_count_of_group_id_bytes' do
        subject { super().position_and_count_of_group_id_bytes }
        it { is_expected.to eq nil }
      end

      describe '#position_and_count_of_encryption_id_bytes' do
        subject { super().position_and_count_of_encryption_id_bytes }
        it { is_expected.to eq nil }
      end
    end

    context "when compression and group id is on" do
      let(:flag_bytes) { [0b00000000, 0b10100000].pack("C2") }

      describe '#preserve_on_tag_alteration?' do
        subject { super().preserve_on_tag_alteration? }
        it { is_expected.to eq(true) }
      end

      describe '#preserve_on_file_alteration?' do
        subject { super().preserve_on_file_alteration? }
        it { is_expected.to eq(true) }
      end

      describe '#read_only?' do
        subject { super().read_only? }
        it { is_expected.to eq(false) }
      end

      describe '#compressed?' do
        subject { super().compressed? }
        it { is_expected.to eq(true) }
      end

      describe '#encrypted?' do
        subject { super().encrypted? }
        it { is_expected.to eq(false) }
      end

      describe '#grouped?' do
        subject { super().grouped? }
        it { is_expected.to eq(true) }
      end

      describe '#unsynchronised?' do
        subject { super().unsynchronised? }
        it { is_expected.to eq(false) }
      end

      describe '#data_length_indicator?' do
        subject { super().data_length_indicator? }
        it { is_expected.to eq(false) }
      end

      describe '#additional_info_byte_count' do
        subject { super().additional_info_byte_count }
        it { is_expected.to eq 5 }
      end

      describe '#position_and_count_of_data_length_bytes' do
        subject { super().position_and_count_of_data_length_bytes }
        it { is_expected.to eq [0, 4] }
      end

      describe '#position_and_count_of_group_id_bytes' do
        subject { super().position_and_count_of_group_id_bytes }
        it { is_expected.to eq [4, 1] }
      end

      describe '#position_and_count_of_encryption_id_bytes' do
        subject { super().position_and_count_of_encryption_id_bytes }
        it { is_expected.to eq nil }
      end
    end

    context "when all flags are 1" do
      let(:flag_bytes) { [0b11100000, 0b11100000].pack("C2") }

      describe '#preserve_on_tag_alteration?' do
        subject { super().preserve_on_tag_alteration? }
        it { is_expected.to eq(false) }
      end

      describe '#preserve_on_file_alteration?' do
        subject { super().preserve_on_file_alteration? }
        it { is_expected.to eq(false) }
      end

      describe '#read_only?' do
        subject { super().read_only? }
        it { is_expected.to eq(true) }
      end

      describe '#compressed?' do
        subject { super().compressed? }
        it { is_expected.to eq(true) }
      end

      describe '#encrypted?' do
        subject { super().encrypted? }
        it { is_expected.to eq(true) }
      end

      describe '#grouped?' do
        subject { super().grouped? }
        it { is_expected.to eq(true) }
      end

      describe '#unsynchronised?' do
        subject { super().unsynchronised? }
        it { is_expected.to eq(false) }
      end

      describe '#data_length_indicator?' do
        subject { super().data_length_indicator? }
        it { is_expected.to eq(false) }
      end

      describe '#additional_info_byte_count' do
        subject { super().additional_info_byte_count }
        it { is_expected.to eq 6 }
      end

      describe '#position_and_count_of_data_length_bytes' do
        subject { super().position_and_count_of_data_length_bytes }
        it { is_expected.to eq [0, 4] }
      end

      describe '#position_and_count_of_group_id_bytes' do
        subject { super().position_and_count_of_group_id_bytes }
        it { is_expected.to eq [5, 1] }
      end

      describe '#position_and_count_of_encryption_id_bytes' do
        subject { super().position_and_count_of_encryption_id_bytes }
        it { is_expected.to eq [4, 1] }
      end
    end
  end

  context "when major version is 4" do
    let(:version) { 4 }
    context "when all flags are nulled" do
      let(:flag_bytes) { [0b00000000, 0b00000000].pack("C2") }

      describe '#preserve_on_tag_alteration?' do
        subject { super().preserve_on_tag_alteration? }
        it { is_expected.to eq(true) }
      end

      describe '#preserve_on_file_alteration?' do
        subject { super().preserve_on_file_alteration? }
        it { is_expected.to eq(true) }
      end

      describe '#read_only?' do
        subject { super().read_only? }
        it { is_expected.to eq(false) }
      end

      describe '#compressed?' do
        subject { super().compressed? }
        it { is_expected.to eq(false) }
      end

      describe '#encrypted?' do
        subject { super().encrypted? }
        it { is_expected.to eq(false) }
      end

      describe '#grouped?' do
        subject { super().grouped? }
        it { is_expected.to eq(false) }
      end

      describe '#unsynchronised?' do
        subject { super().unsynchronised? }
        it { is_expected.to eq(false) }
      end

      describe '#data_length_indicator?' do
        subject { super().data_length_indicator? }
        it { is_expected.to eq(false) }
      end

      describe '#additional_info_byte_count' do
        subject { super().additional_info_byte_count }
        it { is_expected.to eq 0 }
      end

      describe '#position_and_count_of_data_length_bytes' do
        subject { super().position_and_count_of_data_length_bytes }
        it { is_expected.to eq nil }
      end

      describe '#position_and_count_of_group_id_bytes' do
        subject { super().position_and_count_of_group_id_bytes }
        it { is_expected.to eq nil }
      end

      describe '#position_and_count_of_encryption_id_bytes' do
        subject { super().position_and_count_of_encryption_id_bytes }
        it { is_expected.to eq nil }
      end
    end

    context "when compression is on" do
      let(:flag_bytes) { [0b00000000, 0b00001001].pack("C2") }

      describe '#preserve_on_tag_alteration?' do
        subject { super().preserve_on_tag_alteration? }
        it { is_expected.to eq(true) }
      end

      describe '#preserve_on_file_alteration?' do
        subject { super().preserve_on_file_alteration? }
        it { is_expected.to eq(true) }
      end

      describe '#read_only?' do
        subject { super().read_only? }
        it { is_expected.to eq(false) }
      end

      describe '#compressed?' do
        subject { super().compressed? }
        it { is_expected.to eq(true) }
      end

      describe '#encrypted?' do
        subject { super().encrypted? }
        it { is_expected.to eq(false) }
      end

      describe '#grouped?' do
        subject { super().grouped? }
        it { is_expected.to eq(false) }
      end

      describe '#unsynchronised?' do
        subject { super().unsynchronised? }
        it { is_expected.to eq(false) }
      end

      describe '#data_length_indicator?' do
        subject { super().data_length_indicator? }
        it { is_expected.to eq(true) }
      end

      describe '#additional_info_byte_count' do
        subject { super().additional_info_byte_count }
        it { is_expected.to eq 4 }
      end

      describe '#position_and_count_of_data_length_bytes' do
        subject { super().position_and_count_of_data_length_bytes }
        it { is_expected.to eq [0, 4] }
      end

      describe '#position_and_count_of_group_id_bytes' do
        subject { super().position_and_count_of_group_id_bytes }
        it { is_expected.to eq nil }
      end

      describe '#position_and_count_of_encryption_id_bytes' do
        subject { super().position_and_count_of_encryption_id_bytes }
        it { is_expected.to eq nil }
      end
    end

    context "when compression and group id is on" do
      let(:flag_bytes) { [0b00000000, 0b01001001].pack("C2") }

      describe '#preserve_on_tag_alteration?' do
        subject { super().preserve_on_tag_alteration? }
        it { is_expected.to eq(true) }
      end

      describe '#preserve_on_file_alteration?' do
        subject { super().preserve_on_file_alteration? }
        it { is_expected.to eq(true) }
      end

      describe '#read_only?' do
        subject { super().read_only? }
        it { is_expected.to eq(false) }
      end

      describe '#compressed?' do
        subject { super().compressed? }
        it { is_expected.to eq(true) }
      end

      describe '#encrypted?' do
        subject { super().encrypted? }
        it { is_expected.to eq(false) }
      end

      describe '#grouped?' do
        subject { super().grouped? }
        it { is_expected.to eq(true) }
      end

      describe '#unsynchronised?' do
        subject { super().unsynchronised? }
        it { is_expected.to eq(false) }
      end

      describe '#data_length_indicator?' do
        subject { super().data_length_indicator? }
        it { is_expected.to eq(true) }
      end

      describe '#additional_info_byte_count' do
        subject { super().additional_info_byte_count }
        it { is_expected.to eq 5 }
      end

      describe '#position_and_count_of_data_length_bytes' do
        subject { super().position_and_count_of_data_length_bytes }
        it { is_expected.to eq [1, 4] }
      end

      describe '#position_and_count_of_group_id_bytes' do
        subject { super().position_and_count_of_group_id_bytes }
        it { is_expected.to eq [0, 1] }
      end

      describe '#position_and_count_of_encryption_id_bytes' do
        subject { super().position_and_count_of_encryption_id_bytes }
        it { is_expected.to eq nil }
      end
    end

    context "when all flags are 1" do
      let(:flag_bytes) { [0b01110000, 0b01001111].pack("C2") }

      describe '#preserve_on_tag_alteration?' do
        subject { super().preserve_on_tag_alteration? }
        it { is_expected.to eq(false) }
      end

      describe '#preserve_on_file_alteration?' do
        subject { super().preserve_on_file_alteration? }
        it { is_expected.to eq(false) }
      end

      describe '#read_only?' do
        subject { super().read_only? }
        it { is_expected.to eq(true) }
      end

      describe '#compressed?' do
        subject { super().compressed? }
        it { is_expected.to eq(true) }
      end

      describe '#encrypted?' do
        subject { super().encrypted? }
        it { is_expected.to eq(true) }
      end

      describe '#grouped?' do
        subject { super().grouped? }
        it { is_expected.to eq(true) }
      end

      describe '#unsynchronised?' do
        subject { super().unsynchronised? }
        it { is_expected.to eq(true) }
      end

      describe '#data_length_indicator?' do
        subject { super().data_length_indicator? }
        it { is_expected.to eq(true) }
      end

      describe '#additional_info_byte_count' do
        subject { super().additional_info_byte_count }
        it { is_expected.to eq 6 }
      end

      describe '#position_and_count_of_data_length_bytes' do
        subject { super().position_and_count_of_data_length_bytes }
        it { is_expected.to eq [2, 4] }
      end

      describe '#position_and_count_of_group_id_bytes' do
        subject { super().position_and_count_of_group_id_bytes }
        it { is_expected.to eq [0, 1] }
      end

      describe '#position_and_count_of_encryption_id_bytes' do
        subject { super().position_and_count_of_encryption_id_bytes }
        it { is_expected.to eq [1, 1] }
      end
    end
  end
end
