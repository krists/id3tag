module ID3Tag
  module Frames
    module V1
      class TextFrame
        attr_reader :id

        def initialize(id, content)
         @id, @content = id, content
        end

        def content
          @content.encode(destination_encoding, source_encoding)
        end

        private

        def destination_encoding
          Encoding::UTF_8
        end

        def source_encoding
          Encoding::ISO8859_1
        end
      end
    end
  end
end
