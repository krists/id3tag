require "spec_helper"

describe ID3Tag::StringUtil do
  describe "#blank?" do
    subject { described_class.blank?(test_string) }
    context "when test string is like ''" do
      let(:test_string) { "" }
      it { should be_true }
    end

    context "when test string is like '   '" do
      let(:test_string) { "    " }
      it { should be_true }
    end

    context "when test string is like 'foo'" do
      let(:test_string) { "foo" }
      it { should be_false }
    end
  end

  describe "do_unsynchronization" do
    let(:input) { }
    subject { described_class.do_unsynchronization(input) }

    context "when a false synchronization is present" do
      let(:input) { "\xFF\xEE" }
      it { should eq("\xFF\x00\xEE") }
    end
    context "when a false synchronization is not present" do
      let(:input) { "\xEE\xEE" }
      it { should eq("\xEE\xEE") }
    end
  end

  describe "undo_unsynchronization" do
    let(:input) { }
    subject { described_class.undo_unsynchronization(input) }

    context "when unsynchronization in present" do
      let(:input) { "\xFF\x00\xEE\xEE" }
      it { should eq("\xFF\xEE\xEE") }
    end
    context "when unsynchronization in not present" do
      let(:input) { "\xEE\xEE" }
      it { should eq("\xEE\xEE") }
    end
  end
end
