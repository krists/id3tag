# encoding: utf-8
require 'spec_helper'

describe ID3Tag::Frames::V2::GenreFrame::GenreParserPre24 do
  describe '#genres' do

    subject { described_class.new(genre_string).genres }

    context "without refinements" do
      context "with one genre" do
        let(:genre_string) { '(17)' }
        it { is_expected.to eq(['Rock']) }
      end
      context "with multiple genres" do
        let(:genre_string) { '(17)(18)' }
        it { is_expected.to eq(['Rock', 'Techno']) }
      end
      context "with remix and cover" do
        let(:genre_string) { '(RX)(CR)' }
        it { is_expected.to eq(['Remix', 'Cover']) }
      end
    end
    context "with refinements" do
      context "with one genre" do
        let(:genre_string) { '(17)qwerty' }
        it { is_expected.to eq(['qwerty']) }
      end
      context "with miltiple genres but only 1 refinement" do
        let(:genre_string) { '(0)(16)(17)qwerty' }
        it { is_expected.to eq(['Blues', 'Reggae', 'qwerty']) }
      end
      context "with multiple genres" do
        let(:genre_string) { '(17)qwerty(18)abcdef' }
        it { is_expected.to eq(['qwerty', 'abcdef']) }
      end
    end
    context "with refinement containing '('" do
      context "with one genre" do
        let(:genre_string) { '(55)((I think...)' }
        it { is_expected.to eq(['(I think...)']) }
      end
      context "with multiple genres" do
        let(:genre_string) { '(55)((I think...)(17)' }
        it { is_expected.to eq(['(I think...)', 'Rock']) }
      end
    end
  end
end
