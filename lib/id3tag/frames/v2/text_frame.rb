module  ID3Tag
  module Frames
    module  V2
      class TextFrame < BasicFrame
        NULL_BYTE = "\x00"
        UnsupportedTextEncoding = Class.new(StandardError)
        ENCODING_MAP = {
          0b0 => { :encoding => Encoding::ISO8859_1, :terminator => NULL_BYTE },
          0b1 => { :encoding => Encoding::UTF_16, :terminator => NULL_BYTE * 2 },
          0b10 =>{ :encoding => Encoding::UTF_16BE, :terminator => NULL_BYTE * 2 },
          0b11 =>{ :encoding => Encoding::UTF_8, :terminator => NULL_BYTE }
        }

        def content
          @content ||= content_without_encoding_byte.encode(destination_encoding, source_encoding)
        end

        alias inspectable_content content

        private

        def source_encoding
          current_encoding_map[:encoding]
        end

        def current_encoding_map
          ENCODING_MAP.fetch(get_encoding_byte) { raise UnsupportedTextEncoding }
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
