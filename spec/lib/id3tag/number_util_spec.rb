require "spec_helper"
describe ID3Tag::NumberUtil do
  describe "#convert_string_to_32bit_integer" do
    context "when string with 4 bytes given" do
      it "should return integer" do
        expect(described_class.convert_string_to_32bit_integer("abcd")).to eq(1633837924)
      end
    end

    context "when string with less than 4 bytes given" do
      it "should raise Argument error" do
        expect do
          described_class.convert_string_to_32bit_integer("ab")
        end.to raise_error(ArgumentError)
      end
    end
  end

  describe "#convert_32bit_integer_to_string" do
    it "should return 4 byte string" do
      expect(described_class.convert_32bit_integer_to_string(1633837924)).to eq("abcd")
    end
  end
end
