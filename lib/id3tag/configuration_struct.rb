module ID3Tag
  class ConfigurationStruct
    def initialize
      @string_encode_options = {}
      @v2_tag_read_limit = 0
    end

    attr_accessor :string_encode_options
    attr_accessor :v2_tag_read_limit
  end
end
