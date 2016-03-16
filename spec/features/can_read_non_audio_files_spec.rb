require 'spec_helper'
require 'tempfile'

describe 'can read any file and does not raise errors if no tag found' do
  subject { ID3Tag.read(Tempfile.new('fake_mp3')) }

  it 'should return blanks' do
    expect(subject.title).to eq(nil)
    expect(subject.artist).to eq(nil)
    expect(subject.album).to eq(nil)
    expect(subject.genre).to eq(nil)
    expect(subject.year).to eq(nil)
    expect(subject.track_nr).to eq(nil)
    expect(subject.frames).to eq([])
  end
end
