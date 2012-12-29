module ID3Tag
  module Frames
    module V1
      class GenreFrame
        attr_reader :id

        def initialize(id, content)
         @id, @content = id, content
        end

        def content
          nr = @content.unpack("c").first
          nr && Genre::LIST[nr]
        end
      end
    end
  end
end

