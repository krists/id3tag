# encoding: utf-8
require 'spec_helper'

describe ID3Tag::Frames::V2::GenreFrame do
  let(:id) { "TCON" }
  let(:raw_content) { "(17)" }
  let(:flags) { nil }
  let(:major_version_number) { 3 }
  let(:frame) { described_class.new(id, raw_content, flags, major_version_number) }

  describe '#id' do
    subject { frame.id }
    it { should == :TCON }
  end

  describe '#content' do
    subject { frame.content }

    context "when tag major version is pre 3" do
      let(:major_version_number) { 3 }

      context "when one genre" do
        before do
          ID3Tag::Frames::V2::GenreFrame::GenreParserPre24.any_instance.stub(:genres) { ['A'] }
        end

        it { should eq('A') }
      end
      context "when two genres" do
        before do
          ID3Tag::Frames::V2::GenreFrame::GenreParserPre24.any_instance.stub(:genres) { ['A', 'B'] }
        end

        it { should eq('A, B') }
      end
    end

    context "when tag major version is 4" do
      let(:major_version_number) { 4 }
      before do
        ID3Tag::Frames::V2::GenreFrame::GenreParser24.any_instance.stub(:genres) { ['B'] }
      end
      it { should eq('B') }
    end
    context "when tag major version is 232" do
      let(:major_version_number) { 232 }
      it "should raise MissingGenreParser error" do
        expect { subject }.to raise_error(ID3Tag::Frames::V2::GenreFrame::MissingGenreParser)
      end
    end
  end

  describe '#inspect' do
    before do
      frame.stub(:content) { 'Rock' }
    end

    it 'should be pretty inspectable' do
      frame.inspect.should eq('<ID3Tag::Frames::V2::GenreFrame TCON: Rock>')
    end
  end
end
