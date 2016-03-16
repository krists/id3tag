# encoding: utf-8
require 'spec_helper'

describe ID3Tag::Frames::V2::GenreFrame::GenreParser24 do
  describe '#genres' do

    subject { described_class.new(genre_string).genres }

    context "when version is 2.4" do
      context "with remix and cover" do
        let(:genre_string) { "RX\x00CR" }
        it { is_expected.to eq(['Remix', 'Cover']) }
      end
      context "with refinement and number" do
        let(:genre_string) { "ABC\x0017" }
        it { is_expected.to eq(['ABC', 'Rock']) }
      end
      context "with one genre" do
        let(:genre_string) { "17" }
        it { is_expected.to eq(['Rock']) }
      end
    end

  end
end

