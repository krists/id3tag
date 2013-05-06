# encoding: utf-8
require 'spec_helper'

describe ID3Tag::Frames::V2::GenreFrame::GenreParser do
  let(:genre_string) { "17" }
  subject { described_class.new(genre_string) }

  describe '#genres' do
    it "should raise not implemented error" do
      expect { subject.genres }.to raise_error(/genres is not implemented/)
    end
  end
end
