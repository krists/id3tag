module  ID3Tag
  module Frames
    module  V2
      class UserTextFrame < TextFrame

        def content
          StringUtil.cut_at_null_byte(content_parts.last)
        end

        def contents
          StringUtil.split_by_null_bytes(content_parts.last)
        end

        def description
          content_parts.first
        end

        private

        def content_parts
          @parts ||= encoded_content.split(StringUtil::NULL_BYTE, 2)
        end
      end
    end
  end
end
