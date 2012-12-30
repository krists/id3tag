require "spec_helper"

describe ID3Tag::Tag do
  let(:mp3_with_v1_tag) { mp3_fixture('id3v1_without_track_nr.mp3') }
  let(:mp3_with_v1_1_tag) { mp3_fixture('id3v1_with_track_nr.mp3') }
  context "when reading file with v1.x tag" do
    subject { described_class.new(mp3_with_v1_tag)}
    describe "#all_frames" do
      it "reads frames from source" do
        subject.all_frames.size.should > 0
      end
    end

    describe "Class methods" do
      describe "#read" do
        it "should initialize new instance of tag object" do
          described_class.read(mp3_with_v1_tag).should be_instance_of(described_class)
        end
      end
    end

    describe "#get_content_of_text_frame" do
      it "returns string with frames content" do
        subject.get_content_of_text_frame(:TIT2).should == "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaA"
      end
    end

    describe "#get_frame" do
      it "returns string with frames content" do
        subject.get_frame(:TIT2).should be_kind_of(ID3Tag::Frames::V1::TextFrame)
        subject.get_frame(:TIT2).id.should == :TIT2
      end

      it "raises MultipleFrameError when tag has multiple tags with the same id" do
        subject.stub(:all_frames) { [ID3Tag::Frames::V1::TextFrame.new(:TIT2, "some title"), ID3Tag::Frames::V1::TextFrame.new(:TIT2, "some other title")] }
        expect { subject.get_frame(:TIT2) }.to raise_error(ID3Tag::Tag::MultipleFrameError)
      end
    end

    describe "#get_frames" do
      it "returns string with frames content" do
        subject.get_frames(:TIT2).should be_kind_of(Array)
        subject.get_frames(:TIT2).count.should == 1
      end
    end

    describe "#all_frames" do
      context "when file has v2.x tag version" do
        before do
          ID3Tag::AudioFile.any_instance.stub(:v1_tag_present?) { true }
          ID3Tag::AudioFile.any_instance.stub(:v2_tag_present?) { true }
          ID3Tag::ID3V2FrameParser.any_instance.stub(:frames) { [1,2,3] }
        end
        it "should return frames from ID3V2FrameParser class" do
          subject.all_frames.should == [1,2,3]
        end
      end
      context "when file has v2.x tag version" do
        before do
          ID3Tag::AudioFile.any_instance.stub(:v1_tag_present?) { true }
          ID3Tag::AudioFile.any_instance.stub(:v2_tag_present?) { false }
          ID3Tag::ID3V1FrameParser.any_instance.stub(:frames) { [1,2,3] }
        end
        it "should return frames from ID3V1FrameParser class" do
          subject.all_frames.should == [1,2,3]
        end
      end
    end

    describe "#frame_ids" do
      before do
        subject.stub(:all_frames) { [ID3Tag::Frames::V1::TextFrame.new(:TIT2, "some title")] }
      end
      it "returns its of all frames" do
        subject.frame_ids.should == [:TIT2]
      end
    end
  end

  describe "Easy access methods to text frames" do
    subject { described_class.new(mp3_with_v1_1_tag)}
    its(:title) { should == "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaA" }
    its(:artist) { should == "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbB" }
    its(:album) { should == "cccccccccccccccccccccccccccccC" }
    its(:comment) { should == "dddddddddddddddddddddddddddD" }
    its(:genre) { should == "Blues" }
    its(:year) { should == "2003" }
    its(:track_nr) { should == "1" }
  end
end
