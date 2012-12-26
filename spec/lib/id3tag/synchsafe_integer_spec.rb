require "spec_helper"
describe ID3Tag::SynchsafeInteger do
  it "encodes regular integers" do
    described_class.encode(255).should eq(383)
    described_class.encode(5).should eq(5)
    described_class.encode(128).should eq(256)
  end

  it "decodes synchsafe integers" do
    described_class.decode(383).should eq(255)
    described_class.decode(5).should eq(5)
    described_class.decode(256).should eq(128)
  end
end
