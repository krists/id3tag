module  ID3Tag
  module Frames
    module  V2
      class TextFrame < BasicFrame
        class UnsupportedTextEncoding < StandardError; end
        ENCODING_MAP = {
          0b0 => Encoding::ISO8859_1,
          0b1 => Encoding::UTF_16,
          0b10 => Encoding::UTF_16BE,
          0b11 => Encoding::UTF_8
        }

        def content
          @content ||= content_without_encoding_byte.encode(destination_encoding, source_encoding)
        end

        private

        def source_encoding
          ENCODING_MAP[get_encoding_byte] || raise(UnsupportedTextEncoding)
        end

        def destination_encoding
          Encoding::UTF_8
        end

        def get_encoding_byte
          @raw_content.getbyte(0)
        end

        def content_without_encoding_byte
          @raw_content.byteslice(1, @raw_content.bytesize)
        end
      end
    end
  end
end
