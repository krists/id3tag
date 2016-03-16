require "spec_helper"

describe ID3Tag::Frames::Util::GenreNames do

  describe 'self#find_by_id' do
    subject { described_class.find_by_id(id) }

    context "when calling with id 0 what represents Blues" do
      let(:id) { 0 }
      it { is_expected.to eq('Blues') }
    end

    context "when calling with id 17 what represents Rock" do
      let(:id) { 17 }
      it { is_expected.to eq('Rock') }
    end
  end
end
