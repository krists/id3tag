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
        ID3Tag::Frames::V2::GenreFrame.should_receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end

    context "when frame is a genre frame TCO" do
      let(:id) { "TCO" }
      it "fabricates genre frame" do
        ID3Tag::Frames::V2::GenreFrame.should_receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a text frame TIT2" do
      let(:id) { "TIT2" }
      it "fabricates text frame" do
        ID3Tag::Frames::V2::TextFrame.should_receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a user text frame" do
      let(:id) { "TXX" }
      it "fabricates user text frame" do
        ID3Tag::Frames::V2::UserTextFrame.should_receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a comment frame COM" do
      let(:id) { "COMM" }
      it "fabricates comment frame" do
        ID3Tag::Frames::V2::CommentsFrame.should_receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a unique id" do
      let(:id) { "UFID" }
      it "fabricates unique id frame" do
        ID3Tag::Frames::V2::UniqueFileIdFrame.should_receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a unique id" do
      let(:id) { "IPLS" }
      it "fabricates involved people list frame" do
        ID3Tag::Frames::V2::InvolvedPeopleListFrame.should_receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
    context "when frame is a unknown" do
      let(:id) { "unknown" }
      it "fabricates basic frame" do
        ID3Tag::Frames::V2::BasicFrame.should_receive(:new).with(id, content, flags, major_version_number)
        subject
      end
    end
  end
end

