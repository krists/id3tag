module  ID3Tag
  module Frames
    module  V2
      class UniqueFileIdFrame
        attr_reader :id
        def initialize(id, content, flags = nil)
          @id, @raw_content, @flags = id.to_sym, content, flags
        end

        def owner_identifier
          content_split_apart_by_null_byte.first
        end

        def identifier
          content_split_apart_by_null_byte.last
        end

        def content
          @raw_content
        end

        private

        def content_split_apart_by_null_byte
          @raw_content.split("\00", 2)
        end
      end
    end
  end
end
