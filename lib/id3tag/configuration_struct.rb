module ID3Tag
  class ConfigurationStruct
    def initialize
      @string_encode_options = {}
      @v2_tag_read_limit = 0
      @fallback_source_encoding = nil
    end

    attr_accessor :string_encode_options
    attr_accessor :v2_tag_read_limit
    attr_accessor :fallback_source_encoding
  end
end
