module  ID3Tag
  module Frames
    module  V2
      class TextFrame < BasicFrame
        NULL_BYTE = "\x00"
        UnsupportedTextEncoding = Class.new(StandardError)
        ENCODING_MAP = {
          0b0 => Encoding::ISO8859_1,
          0b1 => Encoding::UTF_16,
          0b10 => Encoding::UTF_16BE,
          0b11 => Encoding::UTF_8
        }

        def content
          @content ||= cut_at_null_byte(content_without_encoding_byte.encode(destination_encoding, source_encoding))
        end

        alias inspectable_content content

        def cut_at_null_byte(string)
          string.split(NULL_BYTE, 2).first
        end

        private

        def source_encoding
          ENCODING_MAP.fetch(get_encoding_byte) { raise UnsupportedTextEncoding }
        end

        def current_encoding_map
        end

        def destination_encoding
          Encoding::UTF_8
        end

        def get_encoding_byte
          usable_content.getbyte(0)
        end

        def content_without_encoding_byte
          usable_content.byteslice(1, usable_content.bytesize - 1)
        end
      end
    end
  end
end
