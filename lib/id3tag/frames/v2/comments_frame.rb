module  ID3Tag
  module Frames
    module  V2
      class CommentsFrame < TextFrame
        LANGUAGE_BYTE_COUNT = 3

        # language code according to https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes
        def language
          @language ||= get_language
        end

        def description
          @desciption ||= parts.first
        end

        def text
          @text ||= StringUtil.cut_at_null_byte(parts.last)
        end

        def content
          text
        end

        def inspectable_content
          content
        end

        private

        def parts
          @parts ||= encoded_content.split(StringUtil::NULL_BYTE, 2)
        end

        def encoded_content
          content_without_encoding_byte_and_language.encode(destination_encoding, source_encoding)
        end

        def content_without_encoding_byte_and_language
          raw_content_io.seek(4)
          raw_content_io.read
        end

        def get_language
          raw_content_io.seek(1)
          raw_content_io.read(LANGUAGE_BYTE_COUNT).downcase
        end
      end
    end
  end
end
