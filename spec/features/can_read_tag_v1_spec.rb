require 'spec_helper'

describe 'can read v1 info from file' do
  let(:mp3_with_v1_1_tag) { mp3_fixture('id3v1_with_track_nr.mp3') }
  subject { ID3Tag.read(mp3_with_v1_1_tag) }

  it 'reading file with only v1 tag' do
    expect(subject.title).to eq("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaA")
    expect(subject.artist).to eq("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbB")
    expect(subject.album).to eq("cccccccccccccccccccccccccccccC")
    expect(subject.genre).to eq("Blues")
    expect(subject.year).to eq("2003")
    expect(subject.track_nr).to eq("1")
  end
end
