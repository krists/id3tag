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
          case @id
          when /^(TCON|TCO)$/
            GenreFrame.new(@id, @content, @flags, @major_version_number)
          when /^T/
            TextFrame.new(@id, @content, @flags, @major_version_number)
          when /^(COM|COMM)$/
            CommentsFrame.new(@id, @content, @flags, @major_version_number)
          when /^UFID$/
            UniqueFileIdFrame.new(@id, @content, @flags, @major_version_number)
          else
            BasicFrame.new(@id, @content, @flags, @major_version_number)
          end
        end
      end
    end
  end
end
