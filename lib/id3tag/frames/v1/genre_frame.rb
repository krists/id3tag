module ID3Tag
  module Frames
    module V1
      class GenreFrame
        attr_reader :id

        def initialize(id, content)
         @id, @content = id, content
        end

        def content
          nr = @content.unpack(NumberUtil::FORMAT_FOR_8_BIT_SIGNED_INTEGER).first
          nr && Util::GenreNames.find_by_id(nr)
        end
      end
    end
  end
end

