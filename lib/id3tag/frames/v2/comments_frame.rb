module  ID3Tag
  module Frames
    module  V2
      class CommentsFrame < TextFrame

        # language code according to https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes
        def language
          @language ||= get_language
        end

        def description
          @desciption ||= encoded_text_and_content_parts.first
        end

        def text
          @text ||= encoded_text_and_content_parts.last
        end

        def content
          text
        end

        def inspectable_content
          content
        end

        private

        def encoded_text_and_content_parts
          @encoded_text_and_content_parts ||= encoded_text_and_content.split(current_encoding_map[:terminator], 2)
        end

        def encoded_text_and_content
          raw_text_and_content.encode(destination_encoding, source_encoding)
        end

        def raw_text_and_content
          content_without_encoding_byte[3..-1]
        end

        def get_language
          content_without_encoding_byte[0..2].downcase
        end
      end
    end
  end
end

