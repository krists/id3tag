require "spec_helper"

describe ID3Tag::Tag do
  describe "class method #read"

  context "when file has v2.4.x tag and v.1.x tag" do
    subject { described_class.read(nil) }
    before :each do
      ID3Tag::AudioFile.any_instance.stub(:v2_tag_present?) { true }
      ID3Tag::AudioFile.any_instance.stub(:v2_tag_major_version_number) { 4 }
    end

    describe "#artist" do
      it "reads TPE1 or v1 artist" do
        subject.should_receive(:get_frame_content).with(:TPE1, :artist).and_return('A')
        subject.artist.should eq('A')
      end
    end

    describe "#title" do
      it "reads TIT2 or v1 title" do
        subject.should_receive(:get_frame_content).with(:TIT2, :title).and_return('A')
        subject.title.should eq('A')
      end
    end

    describe "#album" do
      it "reads TALB or v1 album" do
        subject.should_receive(:get_frame_content).with(:TALB, :album).and_return('A')
        subject.album.should eq('A')
      end
    end

    describe "#year" do
      it "reads TDRC or v1 year" do
        subject.should_receive(:get_frame_content).with(:TDRC, :year).and_return('A')
        subject.year.should eq('A')
      end
    end

    describe "#track_nr" do
      it "reads TRCK or v1 track_nr" do
        subject.should_receive(:get_frame_content).with(:TRCK, :track_nr).and_return('A')
        subject.track_nr.should eq('A')
      end
    end

    describe "#genre" do
      it "reads TCON or v1 genre" do
        subject.should_receive(:get_frame_content).with(:TCON, :genre).and_return('A')
        subject.genre.should eq('A')
      end
    end
  end

  describe "#get_frame" do
    subject { described_class.read(nil) }
    context "when more that one frame by that ID exists" do
      before :each do
        subject.stub(:get_frames) { [:frame, :frame] }
      end
      it "should raise MultipleFrameError" do
        expect { subject.get_frame(:some_unique_frame) }.to raise_error(ID3Tag::Tag::MultipleFrameError)
      end
    end

    context "when only one frame by that ID exists" do
      before :each do
        subject.stub(:get_frames) { [:frame] }
      end
      it "should return the frame" do
        subject.get_frame(:some_unique_frame).should eq(:frame)
      end
    end
  end

  describe "#get_frames" do
    subject { described_class.read(nil) }
    let(:a1) { ID3Tag::Frames::V1::TextFrame.new(:A, 'a1') }
    let(:a2) { ID3Tag::Frames::V1::TextFrame.new(:A, 'a2') }
    let(:b) { ID3Tag::Frames::V1::TextFrame.new(:B, 'b') }
    before :each do
      subject.stub(:frames) { [a1, a2, b] }
    end
    it "returns frames with specific IDs" do
      subject.get_frames(:A).should eq([a1, a2])
    end
  end

  describe "#frames" do
    subject { described_class.read(nil) }
    before do
      subject.stub(:v1_frames) { [:v1_frame1, :v1_frame2] }
      subject.stub(:v2_frames) { [:v2_frame1, :v2_frame2] }
    end
    it "returns v2 frames and v1 frames" do
      subject.frames.should eq([:v2_frame1, :v2_frame2, :v1_frame1, :v1_frame2])
    end
  end

  describe "#frame_ids" do
    subject { described_class.read(nil) }
    let(:frame_1) { ID3Tag::Frames::V1::TextFrame.new(:AA, 'a1') }
    let(:frame_2) { ID3Tag::Frames::V1::TextFrame.new(:BB, 'a2') }
    before do
      subject.stub(:frames) { [frame_1, frame_2] }
    end
    it "returns frames ids" do
      subject.frame_ids.should eq([:AA, :BB])
    end
  end

  describe "#v1_frames" do
    context "when tag reading initialized with v1 tag only" do
      subject { described_class.read(nil, :v1) }
      context "when file has v1 tag" do
        before do
          ID3Tag::AudioFile.any_instance.stub(:v1_tag_present?) { true }
          ID3Tag::AudioFile.any_instance.stub(:v1_tag_body) { '' }
          ID3Tag::ID3V1FrameParser.any_instance.stub(:frames) { [:v1_frame] }
        end
        it "reads v1 tags" do
          subject.v1_frames.should eq([:v1_frame])
        end
      end

      context "when file does not have v1 tag" do
        before do
          ID3Tag::AudioFile.any_instance.stub(:v1_tag_present?) { false }
          ID3Tag::AudioFile.any_instance.stub(:v1_tag_body) { '' }
        end
        it "returns empty array" do
          subject.v1_frames.should eq([])
        end
      end
    end

    context "when tag reading initialized with v2 tag only" do
      subject { described_class.read(nil, :v2) }
      context "when file has v1 tag" do
        before do
          ID3Tag::AudioFile.any_instance.stub(:v1_tag_present?) { true }
          ID3Tag::AudioFile.any_instance.stub(:v1_tag_body) { '' }
        end
        it "reads v1 tags" do
          subject.v1_frames.should eq([])
        end
      end
    end

    context "when tag reading initialized with all versions flag" do
      subject { described_class.read(nil, :all) }
      context "when file has v1 tag" do
        before do
          ID3Tag::AudioFile.any_instance.stub(:v1_tag_present?) { true }
          ID3Tag::AudioFile.any_instance.stub(:v1_tag_body) { '' }
          ID3Tag::ID3V1FrameParser.any_instance.stub(:frames) { [:v1_frame] }
        end
        it "reads v1 tags" do
          subject.v1_frames.should eq([:v1_frame])
        end
      end
    end
  end

  describe "#v2_frames" do
    before do
      ID3Tag::AudioFile.any_instance.stub(:v2_tag_major_version_number) { 3 }
    end
    context "when tag reading initialized with v2 tag only" do
      subject { described_class.read(nil, :v2) }
      context "when file has v2 tag" do
        before do
          ID3Tag::AudioFile.any_instance.stub(:v2_tag_present?) { true }
          ID3Tag::AudioFile.any_instance.stub(:v2_tag_body) { '' }
          ID3Tag::ID3V2FrameParser.any_instance.stub(:frames) { [:v2_frame] }
        end
        it "reads v2 tags" do
          subject.v2_frames.should eq([:v2_frame])
        end
      end

      context "when file does not have v2 tag" do
        before do
          ID3Tag::AudioFile.any_instance.stub(:v2_tag_present?) { false }
          ID3Tag::AudioFile.any_instance.stub(:v2_tag_body) { '' }
        end
        it "returns empty array" do
          subject.v2_frames.should eq([])
        end
      end
    end

    context "when tag reading initialized with v1 tag only" do
      subject { described_class.read(nil, :v1) }
      context "when file has v2 tag" do
        before do
          ID3Tag::AudioFile.any_instance.stub(:v2_tag_present?) { true }
          ID3Tag::AudioFile.any_instance.stub(:v2_tag_body) { '' }
        end
        it "returns empty array" do
          subject.v2_frames.should eq([])
        end
      end
    end

    context "when tag reading initialized with all versions flag" do
      subject { described_class.read(nil, :all) }
      context "when file has v2 tag" do
        before do
          ID3Tag::AudioFile.any_instance.stub(:v2_tag_present?) { true }
          ID3Tag::AudioFile.any_instance.stub(:v2_tag_body) { '' }
          ID3Tag::ID3V2FrameParser.any_instance.stub(:frames) { [:v2_frame] }
        end
        it "reads v2 tags" do
          subject.v2_frames.should eq([:v2_frame])
        end
      end
    end
  end

  describe "#get_frame_content" do
    subject { described_class.read(nil, :all) }
    let(:frame_1) { ID3Tag::Frames::V1::TextFrame.new(:some_id, 'some content') }
    let(:frame_2) { ID3Tag::Frames::V1::TextFrame.new(:some_other_id, 'some other content') }
    context "with one ID as argument" do
      context "when frame with ID exists" do
        before :each do
          subject.stub(:get_frame).with(:some_id) { frame_1 }
        end
        it "should return frame" do
          subject.get_frame_content(:some_id).should == 'some content'
        end
      end
      context "when frame with ID does not exists" do
        before :each do
          subject.stub(:get_frame).with(:some_id) { nil }
        end
        it "should return none" do
          subject.get_frame_content(:some_id).should be_nil
        end
      end
    end

    context "with multiple ID as armguments" do
      context "when first one does exist" do
        before :each do
          subject.stub(:get_frame).with(:some_id) { frame_1 }
          subject.stub(:get_frame).with(:some_other_id) { frame_2 }
        end
        it "should return first existing frame's content" do
          subject.get_frame_content(:some_id, :some_other_id).should eq 'some content'
        end
      end
      context "when second exists" do
        before :each do
          subject.stub(:get_frame).with(:some_id) { nil }
          subject.stub(:get_frame).with(:some_other_id) { frame_2 }
        end
        it "should return first existing frame's content" do
          subject.get_frame_content(:some_id, :some_other_id).should eq 'some other content'
        end
      end
    end
  end
end
