require "spec_helper"
describe ID3Tag::AudioFile do
  let(:mp3_with_v1_tag) { mp3_fixture('id3v1_without_track_nr.mp3') }
  let(:mp3_with_v2_tag) { mp3_fixture('id3v2.mp3') }
  let(:mp3_with_v1_and_v2_tags) { mp3_fixture('id3v1_and_v2.mp3') }

  describe "Tag presence checking methods" do
    context "reading file only with ID3v1 tag" do
      subject { described_class.new(mp3_with_v1_tag) }
      its(:v1_tag_present?) { should be_true }
      its(:v2_tag_present?) { should be_false }
    end

    context "reading file only with ID3v2 tag" do
      subject { described_class.new(mp3_with_v2_tag) }
      its(:v1_tag_present?) { should be_false }
      its(:v2_tag_present?) { should be_true }
    end

    context "reading file with ID3v1 and ID3v2 tags" do
      subject { described_class.new(mp3_with_v1_and_v2_tags) }
      its(:v1_tag_present?) { should be_true }
      its(:v2_tag_present?) { should be_true }
    end
  end

  describe "#v1_tag_body" do
    subject { described_class.new(mp3_with_v1_tag) }
    it "should return last 125 bytes of audio file" do
      subject.v1_tag_body.should == File.read(mp3_with_v1_tag, 125, 579)
    end
  end
end
