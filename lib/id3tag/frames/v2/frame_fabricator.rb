module  ID3Tag
  module Frames
    module  V2
      class FrameFabricator
        class << self
          def fabricate(id, content, flags, major_version_number)
            new(id, content, flags, major_version_number).fabricate
          end
        end

        def initialize(id, content, flags, major_version_number)
          @id, @content, @flags, @major_version_number = id, content, flags, major_version_number
        end

        def fabricate
          frame_class.new(@id, @content, @flags, @major_version_number)
        end

        def frame_class
          case @id
          when /^(TCON|TCO)$/
            GenreFrame
          when /^T/
            TextFrame
          when /^(COM|COMM)$/
            CommentsFrame
          when /^UFID$/
            UniqueFileIdFrame
          else
            BasicFrame
          end
        end
      end
    end
  end
end
