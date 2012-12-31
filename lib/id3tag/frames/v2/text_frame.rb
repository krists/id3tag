module  ID3Tag
  module Frames
    module  V2
      class TextFrame < BasicFrame
        def content
          @content ||= content!
        end

        private

        def content!
          @encoding = @raw_content.getbyte(0)
          @raw_content.byteslice(1, @raw_content.bytesize)
        end
      end
    end
  end
end
