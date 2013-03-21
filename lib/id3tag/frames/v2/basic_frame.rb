module  ID3Tag
  module Frames
    module  V2
      class BasicFrame
        attr_reader :id
        def initialize(id, content, flags, major_version_number)
          @id, @raw_content, @flags, @major_version_number = id.to_sym, content, flags, major_version_number
        end

        def content
          @raw_content
        end

        def inspect
          "<#{self.class.name} #{id}: #{inspect_content}>"
        end

        private

        def inspect_content
          content
        end
      end
    end
  end
end
