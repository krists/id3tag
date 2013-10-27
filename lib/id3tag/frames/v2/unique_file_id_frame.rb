module  ID3Tag
  module Frames
    module  V2
      class UniqueFileIdFrame < BasicFrame
        def owner_identifier
          content_split_apart_by_null_byte.first
        end

        def content
          content_split_apart_by_null_byte.last
        end

        def inspectable_content
          "#{owner_identifier}"
        end

        private

        def content_split_apart_by_null_byte
          usable_content.split(StringUtil::NULL_BYTE, 2)
        end
      end
    end
  end
end
