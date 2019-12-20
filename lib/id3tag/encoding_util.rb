module ID3Tag
  module EncodingUtil
    UnsupportedTextEncoding = Class.new(StandardError)
    UnsupportedEncoding = Class.new(StandardError)
    DESTINATION_ENCODING = Encoding::UTF_8.to_s

    ENCODING_MAP = {
      0b0 => Encoding::ISO8859_1,
      0b1 => Encoding::UTF_16,
      0b10 => Encoding::UTF_16BE,
      0b11 => Encoding::UTF_8
    }

    TERMINATOR_MAP = {
      0b0 => 1,
      0b1 => 2,
      0b10 => 2,
      0b11 => 1
    }

    def self.find_encoding(byte)
      ENCODING_MAP.fetch(byte) { raise UnsupportedTextEncoding }.to_s
    end

    def self.terminator_size(byte)
      TERMINATOR_MAP.fetch(byte) { raise UnsupportedEncoding.new("Can not find terminator for encoding byte: #{byte.inspect}") }
    end

    def self.encode(text, source_encoding)
      text.encode(DESTINATION_ENCODING, source_encoding, **ID3Tag.configuration.string_encode_options)
    end
  end
end
