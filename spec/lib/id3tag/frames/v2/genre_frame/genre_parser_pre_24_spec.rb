# encoding: utf-8
require 'spec_helper'

describe ID3Tag::Frames::V2::GenreFrame::GenreParserPre24 do
  describe '#genres' do

    subject { described_class.new(genre_string).genres }

    context "without refinements" do
      context "with one genre" do
        let(:genre_string) { '(17)' }
        it { should == ['Rock'] }
      end
      context "with multiple genres" do
        let(:genre_string) { '(17)(18)' }
        it { should == ['Rock', 'Techno'] }
      end
      context "with remix and cover" do
        let(:genre_string) { '(RX)(CR)' }
        it { should == ['Remix', 'Cover'] }
      end
    end
    context "with refinements" do
      context "with one genre" do
        let(:genre_string) { '(17)qwerty' }
        it { should == ['qwerty'] }
      end
      context "with miltiple genres but only 1 refinement" do
        let(:genre_string) { '(0)(16)(17)qwerty' }
        it { should == ['Blues', 'Reggae', 'qwerty'] }
      end
      context "with multiple genres" do
        let(:genre_string) { '(17)qwerty(18)abcdef' }
        it { should == ['qwerty', 'abcdef'] }
      end
    end
    context "with refinement containing '('" do
      context "with one genre" do
        let(:genre_string) { '(55)((I think...)' }
        it { should == ['(I think...)'] }
      end
      context "with multiple genres" do
        let(:genre_string) { '(55)((I think...)(17)' }
        it { should == ['(I think...)', 'Rock'] }
      end
    end
  end
end
