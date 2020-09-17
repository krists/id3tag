require "spec_helper"

describe ID3Tag::Tag do
  describe ".read" do
    it 'does not raise an error when it has duplicated frames' do
      file = mp3_fixture('duplicated_frames.mp3')
      result = described_class.read(file)

      expect(result.artist).to eq('wetransfer')
      expect(result.title).to eq('wetransfer')
      expect(result.album).to eq('Format Parser')
    end
  end

  describe "#get_frame" do
    subject { described_class.read(nil) }
    context "when more that one frame by that ID exists" do
      before :each do
        allow(subject).to receive(:get_frames) { [:frame, :frame] }
      end
      it "should raise MultipleFrameError" do
        expect { subject.get_frame(:some_unique_frame) }.to raise_error(ID3Tag::Tag::MultipleFrameError)
      end
    end

    context "when only one frame by that ID exists" do
      before :each do
        allow(subject).to receive(:get_frames) { [:frame] }
      end
      it "should return the frame" do
        expect(subject.get_frame(:some_unique_frame)).to eq(:frame)
      end
    end
  end

  describe "#get_frames" do
    subject { described_class.read(nil) }
    let(:a1) { ID3Tag::Frames::V1::TextFrame.new(:A, 'a1') }
    let(:a2) { ID3Tag::Frames::V1::TextFrame.new(:A, 'a2') }
    let(:b) { ID3Tag::Frames::V1::TextFrame.new(:B, 'b') }
    before :each do
      allow(subject).to receive(:frames) { [a1, a2, b] }
    end
    it "returns frames with specific IDs" do
      expect(subject.get_frames(:A)).to eq([a1, a2])
    end
  end

  describe "#frames" do
    subject { described_class.read(nil) }
    before do
      allow(subject).to receive(:v1_frames) { [:v1_frame1, :v1_frame2] }
      allow(subject).to receive(:v2_frames) { [:v2_frame1, :v2_frame2] }
    end
    it "returns v2 frames and v1 frames" do
      expect(subject.frames).to eq([:v2_frame1, :v2_frame2, :v1_frame1, :v1_frame2])
    end
  end

  describe "#frame_ids" do
    subject { described_class.read(nil) }
    let(:frame_1) { ID3Tag::Frames::V1::TextFrame.new(:AA, 'a1') }
    let(:frame_2) { ID3Tag::Frames::V1::TextFrame.new(:BB, 'a2') }
    before do
      allow(subject).to receive(:frames) { [frame_1, frame_2] }
    end
    it "returns frames ids" do
      expect(subject.frame_ids).to eq([:AA, :BB])
    end
  end

  describe "#v1_frames" do
    context "when tag reading initialized with v1 tag only" do
      subject { described_class.read(nil, :v1) }
      context "when file has v1 tag" do
        before do
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v1_tag_present?) { true }
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v1_tag_body) { '' }
          allow_any_instance_of(ID3Tag::ID3V1FrameParser).to receive(:frames) { [:v1_frame] }
        end
        it "reads v1 tags" do
          expect(subject.v1_frames).to eq([:v1_frame])
        end
      end

      context "when file does not have v1 tag" do
        before do
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v1_tag_present?) { false }
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v1_tag_body) { '' }
        end
        it "returns empty array" do
          expect(subject.v1_frames).to eq([])
        end
      end
    end

    context "when tag reading initialized with v2 tag only" do
      subject { described_class.read(nil, :v2) }
      context "when file has v1 tag" do
        before do
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v1_tag_present?) { true }
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v1_tag_body) { '' }
        end
        it "reads v1 tags" do
          expect(subject.v1_frames).to eq([])
        end
      end
    end

    context "when tag reading initialized with all versions flag" do
      subject { described_class.read(nil, :all) }
      context "when file has v1 tag" do
        before do
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v1_tag_present?) { true }
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v1_tag_body) { '' }
          allow_any_instance_of(ID3Tag::ID3V1FrameParser).to receive(:frames) { [:v1_frame] }
        end
        it "reads v1 tags" do
          expect(subject.v1_frames).to eq([:v1_frame])
        end
      end
    end
  end

  describe "#v2_frames" do
    before do
      allow_any_instance_of(ID3Tag::AudioFile).to receive(:v2_tag_major_version_number) { 3 }
    end
    context "when tag reading initialized with v2 tag only" do
      subject { described_class.read(nil, :v2) }
      context "when file has v2 tag" do
        before do
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v2_tag_present?) { true }
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v2_tag_body) { '' }
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v2_tag_size) { 120 }
          allow_any_instance_of(ID3Tag::ID3V2FrameParser).to receive(:frames) { [:v2_frame] }
        end
        it "reads v2 tags" do
          expect(subject.v2_frames).to eq([:v2_frame])
        end
      end

      context "when file does not have v2 tag" do
        before do
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v2_tag_present?) { false }
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v2_tag_body) { '' }
        end
        it "returns empty array" do
          expect(subject.v2_frames).to eq([])
        end
      end
    end

    context "when tag reading initialized with v1 tag only" do
      subject { described_class.read(nil, :v1) }
      context "when file has v2 tag" do
        before do
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v2_tag_present?) { true }
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v2_tag_body) { '' }
        end
        it "returns empty array" do
          expect(subject.v2_frames).to eq([])
        end
      end
    end

    context "when tag reading initialized with all versions flag" do
      subject { described_class.read(nil, :all) }
      context "when file has v2 tag" do
        before do
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v2_tag_present?) { true }
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v2_tag_body) { '' }
          allow_any_instance_of(ID3Tag::AudioFile).to receive(:v2_tag_size) { 120 }
          allow_any_instance_of(ID3Tag::ID3V2FrameParser).to receive(:frames) { [:v2_frame] }
        end
        it "reads v2 tags" do
          expect(subject.v2_frames).to eq([:v2_frame])
        end
      end
    end
  end

  describe "Tests with real-world tags" do
    let(:audio_file) { double("Fake Audio file") }

    subject do
      described_class.new(nil, scope_version).tap do |obj|
        allow(obj).to receive(:audio_file) { audio_file }
      end
    end

    before do
      allow(audio_file).to receive_messages({
                          :v1_tag_present?             => v1_tag_present_flag,
                          :v2_tag_present?             => v2_tag_present_flag,
                          :v1_tag_body                 => v1_tag_body,
                          :v1_tag_size                 => v1_tag_body.to_s.size,
                          :v2_tag_body                 => v2_tag_body,
                          :v2_tag_size                 => v2_tag_body.to_s.size,
                          :v2_tag_major_version_number => v2_tag_major_version_number
                      })
    end

    context "signals_1.mp3.v2_3_tag_body" do
      let(:v1_tag_present_flag) { true }
      let(:v2_tag_present_flag) { true }
      let(:v1_tag_body) {  }
      let(:v2_tag_body) { mp3_fixture("signals_1.mp3.v2_3_tag_body").read }
      let(:v2_tag_major_version_number) { 3 }

      context "Reading only v2" do
        let(:scope_version) { :v2 }

        describe '#artist' do
          subject { super().artist }
          it { is_expected.to eq("Sabled Sun") }
        end

        describe '#title' do
          subject { super().title }
          it { is_expected.to eq("Sabled Sun - Signals I") }
        end

        describe '#album' do
          subject { super().album }
          it { is_expected.to eq("Signals I") }
        end

        describe '#year' do
          subject { super().year }
          it { is_expected.to eq("2013") }
        end

        describe '#track_nr' do
          subject { super().track_nr }
          it { is_expected.to eq "1" }
        end

        describe '#genre' do
          subject { super().genre }
          it { is_expected.to eq "Jazz" }
        end

        describe '#comments' do
          subject { super().comments }
          it { is_expected.to eq("Visit http://cryochamber.bandcamp.com") }
        end
        it "should return eng comment" do
          expect(subject.comments(:eng)).to eq("Visit http://cryochamber.bandcamp.com")
        end
        it "should read private frames" do
          expect(subject.get_frames(:PRIV).find { |f| f.owner_identifier.force_encoding(Encoding::UTF_8) == "WM/MediaClassPrimaryID" }).to be_kind_of(ID3Tag::Frames::V2::PrivateFrame)
        end
      end
    end

    context "pov_20131018-2100a.mp3" do
      let(:v1_tag_present_flag) { true }
      let(:v2_tag_present_flag) { true }
      let(:v1_tag_body) { mp3_fixture("pov_20131018-2100a.mp3.v1_tag_body").read }
      let(:v2_tag_body) { mp3_fixture("pov_20131018-2100a.mp3.v2_3_tag_body").read }
      let(:v2_tag_major_version_number) { 3 }

      context "Reading only v1" do
        let(:scope_version) { :v1 }

        describe '#artist' do
          subject { super().artist }
          it { is_expected.to eq("") }
        end

        describe '#title' do
          subject { super().title }
          it { is_expected.to eq("pov_20131018-2100a.mp3") }
        end

        describe '#album' do
          subject { super().album }
          it { is_expected.to eq("") }
        end

        describe '#year' do
          subject { super().year }
          it { is_expected.to eq("") }
        end

        describe '#track_nr' do
          subject { super().track_nr }
          it { is_expected.to be_nil }
        end

        describe '#genre' do
          subject { super().genre }
          it { is_expected.to eq("Blues") }
        end

        describe '#comments' do
          subject { super().comments }
          it { is_expected.to be_nil }
        end

        describe '#frame_ids' do
          subject { super().frame_ids }
          it { is_expected.to eq [:title, :artist, :album, :year, :comments, :genre] }
        end
      end
      context "Reading only v2" do
        let(:scope_version) { :v2 }

        describe '#artist' do
          subject { super().artist }
          it { is_expected.to eq("BBC Radio 4") }
        end

        describe '#title' do
          subject { super().title }
          it { is_expected.to eq("PoV: Lisa Jardine: Machine Intelligence: 18 Oct 13") }
        end

        describe '#album' do
          subject { super().album }
          it { is_expected.to eq("A Point of View") }
        end

        describe '#year' do
          subject { super().year }
          it { is_expected.to eq("2013") }
        end

        describe '#track_nr' do
          subject { super().track_nr }
          it { is_expected.to be_nil }
        end
        it "should return nil for genre as this tag have incorect genre frame" do
          expect(subject.genre).to eq("")
        end

        describe '#comments' do
          subject { super().comments }
          it { is_expected.to eq("Lisa Jardine compares the contributions of Ada Lovelace and Alan Turing a century later to computer science and contrasts their views on the potential of and limits to machine intelligence. \r\nProducer: Sheila Cook") }
        end
        it "should return eng comment" do
          expect(subject.comments(:eng)).to eq("Lisa Jardine compares the contributions of Ada Lovelace and Alan Turing a century later to computer science and contrasts their views on the potential of and limits to machine intelligence. \r\nProducer: Sheila Cook")
        end
        it "should return blank string for latvian comments" do
          expect(subject.comments(:lav)).to be_nil
        end

        describe '#frame_ids' do
          subject { super().frame_ids }
          it { is_expected.to eq [:TALB, :TPE1, :COMM, :USLT, :TCON, :TIT2, :TYER, :TCOP, :APIC] }
        end
        it "should have comments frame with short desc and language code" do
          expect(subject.get_frames(:COMM).size).to eq(1)
          expect(subject.get_frame(:COMM).language).to eq("eng")
          expect(subject.get_frame(:COMM).description).to eq("")
        end
      end
    end
  end
end
