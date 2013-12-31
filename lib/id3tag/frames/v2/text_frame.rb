module  ID3Tag
  module Frames
    module  V2
      class TextFrame < BasicFrame
        UnsupportedTextEncoding = Class.new(StandardError)
        ENCODING_MAP = {
          0b0 => Encoding::ISO8859_1,
          0b1 => Encoding::UTF_16,
          0b10 => Encoding::UTF_16BE,
          0b11 => Encoding::UTF_8
        }

        def content
          @content ||= StringUtil.cut_at_null_byte(encoded_content)
        end

        def inspectable_content
          content
        end

        private

        def encoded_content
          content_without_encoding_byte.encode(destination_encoding, source_encoding, ID3Tag.configuration.string_encode_options)
        end

        def source_encoding
          ENCODING_MAP.fetch(get_encoding_byte) { raise UnsupportedTextEncoding }.to_s
        end

        def destination_encoding
          Encoding::UTF_8.to_s
        end

        def get_encoding_byte
          raw_content_io.rewind
          raw_content_io.getbyte
        end

        def content_without_encoding_byte
          raw_content_io.seek(1)
          raw_content_io.read
        end
      end
    end
  end
end
