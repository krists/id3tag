require "spec_helper"

describe ID3Tag do
  let(:file) { mp3_fixture('id3v2.mp3') }
  describe "#read" do
    it "reads file tag" do
      expect(ID3Tag.read(file)).to be_instance_of(ID3Tag::Tag)
    end

    it "accepts block" do
      expect do |b|
        ID3Tag.read(file, &b)
      end.to yield_control
    end
  end

  describe "#configuration" do
    it "delegates to configuration instance" do
      expect(ID3Tag.configuration.v2_tag_read_limit).to eq(0)
      expect(ID3Tag::Configuration.configuration.v2_tag_read_limit).to eq(0)
      ID3Tag.configuration.v2_tag_read_limit = 1024
      expect(ID3Tag.configuration.v2_tag_read_limit).to eq(1024)
      expect(ID3Tag::Configuration.configuration.v2_tag_read_limit).to eq(1024)
    end

    it "accepts block" do
      expect do |b|
        ID3Tag.configuration(&b)
      end.to yield_control
    end
  end

  describe "#local_configuration" do
    it "delegates to configuration instance" do
      expect(ID3Tag.configuration.v2_tag_read_limit).to eq(0)
      ID3Tag.local_configuration do
        expect(ID3Tag.configuration.v2_tag_read_limit).to eq(0)
        ID3Tag.configuration.v2_tag_read_limit = 1024
        expect(ID3Tag.configuration.v2_tag_read_limit).to eq(1024)
      end
      expect(ID3Tag.configuration.v2_tag_read_limit).to eq(0)
      expect(ID3Tag::Configuration.configuration.v2_tag_read_limit).to eq(0)
    end

    it "can be nested multiple times" do
      expect(ID3Tag.configuration.v2_tag_read_limit).to eq(0)
      ID3Tag.local_configuration do |c|
        c.v2_tag_read_limit = 1
        expect(ID3Tag.configuration.v2_tag_read_limit).to eq(1)
        ID3Tag.local_configuration do |c2|
          c2.v2_tag_read_limit = 2
          expect(ID3Tag.configuration.v2_tag_read_limit).to eq(2)
          ID3Tag.local_configuration do |c3|
            expect(ID3Tag.configuration.v2_tag_read_limit).to eq(2)
            c3.v2_tag_read_limit = 3
            expect(ID3Tag.configuration.v2_tag_read_limit).to eq(3)
          end
          expect(ID3Tag.configuration.v2_tag_read_limit).to eq(2)
        end
        expect(ID3Tag.configuration.v2_tag_read_limit).to eq(1)
      end
      expect(ID3Tag.configuration.v2_tag_read_limit).to eq(0)
    end
  end

  describe "#reset_configuration" do
    it "allows to reset configuration to defaults" do
      expect(ID3Tag.configuration.v2_tag_read_limit).to eq(0)
      ID3Tag.configuration.v2_tag_read_limit = 1024
      expect(ID3Tag.configuration.v2_tag_read_limit).to eq(1024)
      ID3Tag.reset_configuration
      expect(ID3Tag::Configuration.configuration.v2_tag_read_limit).to eq(0)
    end

    it "cannot be called within local_configuration block" do
      ID3Tag.configuration.v2_tag_read_limit = 1024
      ID3Tag.local_configuration do
        expect do
          ID3Tag.reset_configuration
        end.to raise_error(ID3Tag::Configuration::ResetError)
      end
      expect(ID3Tag.configuration.v2_tag_read_limit).to eq(1024)
    end
  end
end

