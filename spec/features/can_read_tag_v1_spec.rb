require 'spec_helper'

describe 'can read v1 info from file' do
  let(:mp3_with_v1_1_tag) { mp3_fixture('id3v1_with_track_nr.mp3') }
  subject { ID3Tag.read(mp3_with_v1_1_tag) }

  it 'reading file with only v1 tag' do
    subject.title.should == "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaA"
    subject.artist.should == "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbB"
    subject.album.should == "cccccccccccccccccccccccccccccC"
    subject.genre.should == "Blues"
    subject.year.should == "2003"
    subject.track_nr.should == "1"
  end
end
