require 'spec_helper'

describe 'can read any file and does not raise errors if no tag found' do
  subject { ID3Tag.read(File.open('/dev/null')) }

  it 'reading file with only v1 tag' do
    subject.title.should == nil
    subject.artist.should == nil
    subject.album.should == nil
    subject.comments.should == nil
    subject.genre.should == nil
    subject.year.should == nil
    subject.track_nr.should == nil
    subject.frames.should == []
  end
end
