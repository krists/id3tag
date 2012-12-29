module ID3Tag
  module Frames
    module V1
      class TextFrame
        attr_reader :id, :content

        def initialize(id, content)
         @id, @content = id, content
        end
      end
    end
  end
end
