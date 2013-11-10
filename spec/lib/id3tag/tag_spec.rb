require "spec_helper"

describe ID3Tag::Tag do
  describe "class method #read"

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

  describe "Tests with real-world tags" do
    let(:audio_file) { double("Fake Audio file") }

    context "signals_1.mp3.v2_3_tag_body" do
      before(:each) do
        subject.stub(:audio_file) { audio_file }
        audio_file.stub({
          :v1_tag_present? => true,
          :v2_tag_present? => true,
          :v2_tag_body => File.read(mp3_fixture("signals_1.mp3.v2_3_tag_body")),
          :v2_tag_major_version_number => 3
        })
      end
      context "Reading only v2" do
        subject { described_class.new(nil, :v2) }
        its(:artist) { should eq("Sabled Sun") }
        its(:title) { should eq("Sabled Sun - Signals I") }
        its(:album) { should eq("Signals I") }
        its(:year) { should eq("2013") }
        its(:track_nr) { should eq "1" }
        its(:genre) { should eq "Jazz" }
        its(:comments) { should eq("Visit http://cryochamber.bandcamp.com") }
        it "should return eng comment" do
          subject.comments(:eng).should eq("Visit http://cryochamber.bandcamp.com")
        end
        it "should read private frames" do
          subject.get_frames(:PRIV).find { |f| f.owner_identifier == "WM/MediaClassPrimaryID" }.should be_kind_of(ID3Tag::Frames::V2::PrivateFrame)
        end
      end
    end

    context "pov_20131018-2100a.mp3" do
      before(:each) do
        subject.stub(:audio_file) { audio_file }
        audio_file.stub({
          :v1_tag_present? => true,
          :v2_tag_present? => true,
          :v1_tag_body => File.read(mp3_fixture("pov_20131018-2100a.mp3.v1_tag_body")),
          :v2_tag_body => File.read(mp3_fixture("pov_20131018-2100a.mp3.v2_3_tag_body")),
          :v2_tag_major_version_number => 3
        })
      end
      context "Reading only v1" do
        subject { described_class.new(nil, :v1) }
        its(:artist) { should eq("") }
        its(:title) { should eq("pov_20131018-2100a.mp3") }
        its(:album) { should eq("") }
        its(:year) { should eq("") }
        its(:track_nr) { should be_nil }
        its(:genre) { should eq("Blues") }
        its(:comments) { should be_nil }
        its(:frame_ids) { should eq [:title, :artist, :album, :year, :comments, :genre] }
      end
      context "Reading only v2" do
        subject { described_class.new(nil, :v2) }
        its(:artist) { should eq("BBC Radio 4") }
        its(:title) { should eq("PoV: Lisa Jardine: Machine Intelligence: 18 Oct 13") }
        its(:album) { should eq("A Point of View") }
        its(:year) { should eq("2013") }
        its(:track_nr) { should be_nil }
        it "should return nil for genre as this tag have incorect genre frame" do
          subject.genre.should eq("")
        end
        its(:comments) { should eq("Lisa Jardine compares the contributions of Ada Lovelace and Alan Turing a century later to computer science and contrasts their views on the potential of and limits to machine intelligence. \r\nProducer: Sheila Cook") }
        it "should return eng comment" do
          subject.comments(:eng).should eq("Lisa Jardine compares the contributions of Ada Lovelace and Alan Turing a century later to computer science and contrasts their views on the potential of and limits to machine intelligence. \r\nProducer: Sheila Cook")
        end
        it "should return blank string for latvian comments" do
          subject.comments(:lav).should be_nil
        end
        its(:frame_ids) { should eq [:TALB, :TPE1, :COMM, :USLT, :TCON, :TIT2, :TYER, :TCOP, :APIC] }
        it "should have comments frame with short desc and language code" do
          subject.get_frames(:COMM).size.should eq(1)
          subject.get_frame(:COMM).language.should eq("eng")
          subject.get_frame(:COMM).description.should eq("")
        end
      end
    end
  end
end
