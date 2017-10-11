require "spec_helper"
describe ID3Tag::AudioFile do
  let(:mp3_with_v1_tag) { mp3_fixture('id3v1_without_track_nr.mp3') }
  let(:mp3_with_v2_tag) { mp3_fixture('id3v2.mp3') }
  let(:mp3_with_v1_and_v2_tags) { mp3_fixture('id3v1_and_v2.mp3') }
  let(:broken_mp3) do
    file = Tempfile.new("broken_mp3")
    file.write("just something..but not enough")
    file
  end

  describe "Tag presence checking methods" do
    context "reading file only with ID3v1 tag" do
      subject { described_class.new(mp3_with_v1_tag) }

      describe '#v1_tag_present?' do
        subject { super().v1_tag_present? }
        it { is_expected.to eq(true) }
      end

      describe '#v1_tag_size' do
        subject { super().v1_tag_size }
        it { is_expected.to eq(125) }
      end


      describe '#v2_tag_present?' do
        subject { super().v2_tag_present? }
        it { is_expected.to eq(false) }
      end

      describe '#v2_tag_size' do
        subject { super().v2_tag_size }
        it { is_expected.to eq(0) }
      end
    end

    context "reading file only with ID3v2 tag" do
      subject { described_class.new(mp3_with_v2_tag) }

      describe '#v1_tag_present?' do
        subject { super().v1_tag_present? }
        it { is_expected.to eq(false) }
      end

      describe '#v1_tag_size' do
        subject { super().v1_tag_size }
        it { is_expected.to eq(0) }
      end

      describe '#v2_tag_present?' do
        subject { super().v2_tag_present? }
        it { is_expected.to eq(true) }
      end

      describe '#v2_tag_size' do
        subject { super().v2_tag_size }
        it { is_expected.to eq(246) }
      end
    end

    context "reading file with ID3v1 and ID3v2 tags" do
      subject { described_class.new(mp3_with_v1_and_v2_tags) }

      describe '#v1_tag_present?' do
        subject { super().v1_tag_present? }
        it { is_expected.to eq(true) }
      end

      describe '#v2_tag_present?' do
        subject { super().v2_tag_present? }
        it { is_expected.to eq(true) }
      end
    end
  end

  describe "#v1_tag_body" do
    context "when reading file with alteast 125 bytes" do
      subject { described_class.new(mp3_with_v1_tag) }
      it "should return last 125 bytes of audio file" do
        expect(subject.v1_tag_body).to eq(File.read(mp3_with_v1_tag, 125, 579))
      end
    end
    context "when reading file with size less ID3v1 tag" do
      subject { described_class.new(broken_mp3) }
      it "should return as much bytes as possible" do
        expect(subject.v1_tag_body).to eq(nil)
      end
    end
  end

  describe "#v2_tag_body" do
    context "when extended header is not present" do
      subject { described_class.new(StringIO.new("ID3\u0003\u0000\u0000\u0000\u0000\u0000\u0003ABC")) }
      it "should return frame and padding bytes" do
        expect(subject.v2_tag_body).to eq("ABC")
      end
    end
    context "when extended header is present" do
      subject { described_class.new(StringIO.new("ID3\u0003\u0000\u0040\u0000\u0000\u0000\u0011" + "\u0000\u0000\u0000\u000A" + ("\u0000" * 10) + "ABC")) }
      it "should return frame and padding bytes" do
        expect(subject.v2_tag_body).to eq("ABC")
      end
      context "when tag verison is v.2.4 and extended header size is calculated differently" do
        subject { described_class.new(StringIO.new("ID3\u0004\u0000\u0040\u0000\u0000\u0000\u0011" + "\u0000\u0000\u0000\u000A" + ("\u0000" * 6) + "ABC")) }
        it "should return frame and padding bytes" do
          expect(subject.v2_tag_body).to eq("ABC")
        end
      end
    end
  end

  context "when reading file with v2.3.0 tag" do
    subject { described_class.new(StringIO.new("ID3\u0003\u0000")) }

    describe '#v2_tag_version' do
      subject { super().v2_tag_version }
      it { is_expected.to eq '3.0' }
    end

    describe '#v2_tag_major_version_number' do
      subject { super().v2_tag_major_version_number }
      it { is_expected.to eq 3 }
    end

    describe '#v2_tag_minor_version_number' do
      subject { super().v2_tag_minor_version_number }
      it { is_expected.to eq 0 }
    end
  end
end
