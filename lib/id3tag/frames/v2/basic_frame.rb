module  ID3Tag
  module Frames
    module  V2
      class BasicFrame
        attr_reader :id
        def initialize(id, content, flags = nil)
          @id, @raw_content, @flags = id.to_sym, content, flags
        end

        def content
          @raw_content
        end
      end
    end
  end
end
