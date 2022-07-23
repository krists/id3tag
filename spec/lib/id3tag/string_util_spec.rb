require "spec_helper"

describe ID3Tag::StringUtil do
  describe "#blank?" do
    subject { described_class.blank?(test_string) }
    context "when test string is like ''" do
      let(:test_string) { "" }
      it { is_expected.to eq(true) }
    end

    context "when test string is like '   '" do
      let(:test_string) { "    " }
      it { is_expected.to eq(true) }
    end

    context "when test string is like 'foo'" do
      let(:test_string) { "foo" }
      it { is_expected.to eq(false) }
    end
  end

  describe "do_unsynchronization" do
    let(:input) { }
    subject { described_class.do_unsynchronization(input) }

    context "when a false synchronization is present" do
      let(:input) { "\xFF\xE0" }
      it { is_expected.to eq("\xFF\x00\xE0") }
    end
    context "when an unsynchronization marker is present" do
      let(:input) { "\xFF\x00" }
      it { is_expected.to eq("\xFF\x00\x00") }
    end
    context "when \\xFF is at the end of the data" do
      let(:input) { "\xFF" }
      it { is_expected.to eq("\xFF") }
    end
    context "when a false synchronization is not present" do
      let(:input) { "\xFF\x01" }
      it { is_expected.to eq("\xFF\x01") }
    end
  end

  describe "undo_unsynchronization" do
    let(:input) { }
    subject { described_class.undo_unsynchronization(input) }

    context "when unsynchronization in present" do
      let(:input) { "\xFF\x00\xE0" }
      it { is_expected.to eq("\xFF\xE0") }
    end
    context "when false unsynchronization in present" do
      let(:input) { "\xFF\x00" }
      it { is_expected.to eq("\xFF\x00") }
    end
    context "when an unsynchronization marker is present" do
      let(:input) { "\xFF\x00\x00" }
      it { is_expected.to eq("\xFF\x00") }
    end
    context "when \\xFF is at the end of the data" do
      let(:input) { "\xFF" }
      it { is_expected.to eq("\xFF") }
    end
    context "when unsynchronization in not present" do
      let(:input) { "\xFF\x01" }
      it { is_expected.to eq("\xFF\x01") }
    end
  end

  describe "cut_at_null_byte" do
    let(:input) { }
    subject { described_class.cut_at_null_byte(input) }

    context 'when content is empty' do
      let(:input) { '' }
      it { is_expected.to eq('') }
    end

    context 'when content is present' do
      let(:input) { "a\u0000b" }
      it { is_expected.to eq('a') }
    end
  end

  describe "split_by_null_byte" do
    let(:input) { }
    subject { described_class.split_by_null_byte(input) }
    context "when content have only 1 null byte" do
      let(:input) { "a\u0000b" }
      it { is_expected.to eq(["a", "b"]) }
    end
    context "when content have multiple null bytes" do
      let(:input) { "a\u0000\u0000b" }
      it { is_expected.to eq(["a", "\u0000b"]) }
    end
    context "when content have no null bytes" do
      let(:input) { "abc" }
      it { is_expected.to eq(["abc", ""]) }
    end
  end

  describe "split_by_null_bytes" do
    let(:input) { }
    subject { described_class.split_by_null_bytes(input) }
    context "when content have only 1 null byte" do
      let(:input) { "a\u0000b" }
      it { is_expected.to eq(["a", "b"]) }
    end
    context "when content have multiple null bytes" do
      let(:input) { "a\u0000\u0000b" }
      it { is_expected.to eq(["a", "", "b"]) }
    end
    context "when content have no null bytes" do
      let(:input) { "abc" }
      it { is_expected.to eq(["abc"]) }
    end
  end

  describe "chomp_null_byte" do
    let(:input) { }
    subject { described_class.chomp_null_byte(input) }
    context "when content has trailing null byte" do
      let(:input) { "a\u0000b\u0000" }
      it { is_expected.to eq("a\u0000b") }
    end
    context "when content have no trailing null bytes" do
      let(:input) { "a\u0000b" }
      it { is_expected.to eq("a\u0000b") }
    end
  end
end
