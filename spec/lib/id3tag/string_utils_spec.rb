require "spec_helper"

describe ID3Tag::StringUtils do
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
end
