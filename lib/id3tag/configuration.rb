module ID3Tag
  class Configuration
    def initialize
      @string_encode_options = {}
      @string_source_encoding = nil
    end

    attr_accessor :string_encode_options
    attr_accessor :string_source_encoding
  end
end
