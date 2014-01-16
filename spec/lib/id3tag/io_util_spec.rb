require "spec_helper"

describe ID3Tag::IOUtil do

  describe "#read_until_terminator" do
    subject { ID3Tag::IOUtil.read_until_terminator(io, group_size) }
    context "when reading IO and looking for UTF-8 terminator - 1 null byte" do
      let(:group_size) { 1 }
      context "when only 1 null byte present" do
        let(:io) { StringIO.new("abcd\x00ef") }
        it { should eq("abcd") }
      end
      context "when no null bytes are present" do
        let(:io) { StringIO.new("abcdef") }
        it { should eq("abcdef") }
      end
    end
    context "when reading IO and looking for UTF-16 terminator - 2 null bytes" do
      let(:group_size) { 2 }
      context "when only 1 null byte present" do
        let(:io) { StringIO.new("a\x00b\x00\x00\x00c\x00") }
        it "should return content until terminator and leave cursor just right after" do
          subject.should eq("a\x00b\x00")
          io.read.should eq("c\x00")
        end
      end
    end
  end

end
