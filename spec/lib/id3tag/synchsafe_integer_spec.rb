require "spec_helper"
describe ID3Tag::SynchsafeInteger do
  it "encodes regular integers" do
    expect(described_class.encode(255)).to eq(383)
    expect(described_class.encode(5)).to eq(5)
    expect(described_class.encode(128)).to eq(256)
  end

  it "decodes synchsafe integers" do
    expect(described_class.decode(383)).to eq(255)
    expect(described_class.decode(5)).to eq(5)
    expect(described_class.decode(256)).to eq(128)
  end
end
