require 'spec_helper'

describe ID3Tag::Frames::V2::FrameFabricator do
  let(:id) { nil }
  let(:content) { 'some content' }
  let(:flags) { nil }
  let(:major_version_number) { 4 }

  describe "self#fabricate" do
    subject { described_class.fabricate(id, content, flags, major_version_number) }
    context "when frame is a genre frame TCON" do
      let(:id) { "TCON" }
      it "fabricates genre frame" do
        expect(ID3Tag::Frames::V2::GenreFrame).to receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end

    context "when frame is a genre frame TCO" do
      let(:id) { "TCO" }
      it "fabricates genre frame" do
        expect(ID3Tag::Frames::V2::GenreFrame).to receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a text frame TIT2" do
      let(:id) { "TIT2" }
      it "fabricates text frame" do
        expect(ID3Tag::Frames::V2::TextFrame).to receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a user text frame" do
      let(:id) { "TXX" }
      it "fabricates user text frame" do
        expect(ID3Tag::Frames::V2::UserTextFrame).to receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a user URL frame" do
      let(:id) { "WXXX" }
      it "fabricates user text frame" do
        expect(ID3Tag::Frames::V2::UserUrlFrame).to receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a URL frame" do
      let(:id) { "W" }
      it "fabricates user text frame" do
        expect(ID3Tag::Frames::V2::UrlFrame).to receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a comment frame COM" do
      let(:id) { "COMM" }
      it "fabricates comment frame" do
        expect(ID3Tag::Frames::V2::CommentsFrame).to receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a unique id" do
      let(:id) { "UFID" }
      it "fabricates unique id frame" do
        expect(ID3Tag::Frames::V2::UniqueFileIdFrame).to receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a unique id" do
      let(:id) { "IPLS" }
      it "fabricates involved people list frame" do
        expect(ID3Tag::Frames::V2::InvolvedPeopleListFrame).to receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a chapter" do
      let(:id) { "CHAP" }
      it "fabricates chapter frame" do
        expect(ID3Tag::Frames::V2::ChapterFrame).to receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a table of contents" do
      let(:id) { "CTOC" }
      it "fabricates chapter frame" do
        expect(ID3Tag::Frames::V2::TableOfContentsFrame).to receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a unknown" do
      let(:id) { "unknown" }
      it "fabricates basic frame" do
        expect(ID3Tag::Frames::V2::BasicFrame).to receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
  end
end
