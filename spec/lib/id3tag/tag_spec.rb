require "spec_helper"

describe ID3Tag::Tag do
  let(:mp3_with_v1_tag) { mp3_fixture('id3v1_without_track_nr.mp3') }
  context "when reading file with v1.x tag" do
    subject { described_class.new(mp3_with_v1_tag)}
    describe "#frames" do
      it "reads frames from source" do
        subject.frames.size.should > 0
      end
    end
  end
end
