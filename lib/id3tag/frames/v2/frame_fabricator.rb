module  ID3Tag
  module Frames
    module  V2
      class FrameFabricator
        class << self
          def fabricate(id, content, flags = nil)
            new(id, content, flags).fabricate
          end
        end

        def initialize(id, content, flags = nil)
          @id, @content, @flags = id, content, flags
        end

        def fabricate
          case @id
          when /^T/
            TextFrame.new(@id, @content, @flags)
          when /^UFID/
            UniqueFileIdFrame.new(@id, content, @flags)
          else
            BasicFrame.new(@id, @content, @flags)
          end
        end
      end
    end
  end
end
