require "spec_helper"

describe ID3Tag::Configuration do
  describe "global accessors" do
    it "allows to set & get string_encode_options" do
      ID3Tag::Configuration.configuration.string_encode_options = { :invalid => :replace, :undef => :replace }
      expect(ID3Tag::Configuration.configuration.string_encode_options).to eq({ :invalid => :replace, :undef => :replace })
    end

    it "allows to set & get string_encode_options" do
      ID3Tag::Configuration.configuration.v2_tag_read_limit = 123
      expect(ID3Tag::Configuration.configuration.v2_tag_read_limit).to eq(123)
    end

    it "can be configured using block" do
      expect(ID3Tag::Configuration.configuration.string_encode_options).to eq({})
      expect(ID3Tag::Configuration.configuration.v2_tag_read_limit).to eq(0)
      ID3Tag::Configuration.configuration do |config|
        config.string_encode_options = { :invalid => :replace }
        config.v2_tag_read_limit = 456
      end
      expect(ID3Tag::Configuration.configuration.string_encode_options).to eq({ :invalid => :replace })
      expect(ID3Tag::Configuration.configuration.v2_tag_read_limit).to eq(456)
    end
  end

  describe "local configuration" do
    it "allows to set local configuration to block and iherit values from global configuration" do
      expect(ID3Tag::Configuration.configuration.string_encode_options).to eq({})
      expect(ID3Tag::Configuration.configuration.v2_tag_read_limit).to eq(0)

      # write some global state
      ID3Tag::Configuration.configuration.v2_tag_read_limit = 999
      expect(ID3Tag::Configuration.configuration.v2_tag_read_limit).to eq(999)

      ID3Tag::Configuration.local_configuration do |id3_tag_configuration|
        expect(ID3Tag::Configuration.configuration.v2_tag_read_limit).to eq(999)

        ID3Tag::Configuration.configuration.v2_tag_read_limit = 888 # write using global syntax
        id3_tag_configuration.string_encode_options = { :invalid => :replace } # write using block variable

        expect(ID3Tag::Configuration.configuration.v2_tag_read_limit).to eq(888)
        expect(ID3Tag::Configuration.configuration.string_encode_options).to eq({ :invalid => :replace })
      end

      # Check if global state is maintained
      expect(ID3Tag::Configuration.configuration.string_encode_options).to eq({})
      expect(ID3Tag::Configuration.configuration.v2_tag_read_limit).to eq(999)
    end
  end
end

