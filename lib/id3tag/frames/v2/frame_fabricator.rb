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
          when /^TXX/
            UserTextFrame
          when /^T/
            TextFrame
          when /^WXXX$/
            UserUrlFrame
          when /^(COM|COMM)$/
            CommentsFrame
          when /^(ULT|USLT)$/
            UnsychronizedTranscriptionFrame
          when /^UFID$/
            UniqueFileIdFrame
          when /^(IPL|IPLS)$/
            InvolvedPeopleListFrame
          when /^(PIC|APIC)$/
            PictureFrame
          when /^PRIV$/
            PrivateFrame
          when /^CHAP$/
            ChapterFrame
          when /^CTOC$/
            TableOfContentsFrame
          else
            BasicFrame
          end
        end
      end
    end
  end
end
