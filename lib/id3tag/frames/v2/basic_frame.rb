module  ID3Tag
  module Frames
    module  V2
      class BasicFrame
        DECOMPRESSED_SIZE_BYTE_COUNT = 4
        GROUP_BYTE_COUNT = 1

        attr_reader :id, :raw_content

        def initialize(id, content, flags, major_version_number)
          @id, @raw_content, @flags, @major_version_number = id.to_sym, content, flags, major_version_number
        end

        def content
          unpacked_content
        end

        def unpacked_content
          raw_content_io.rewind
          offset = 0
          offset += DECOMPRESSED_SIZE_BYTE_COUNT if compressed?
          offset += GROUP_BYTE_COUNT if grouped?
          raw_content_io.seek(offset)
          raw_content_io.read
        end

        def group_id
          if grouped?
            raw_content_io.rewind
            offset = 0
            offset += DECOMPRESSED_SIZE_BYTE_COUNT if compressed?
            raw_content_io.seek(offset)
            raw_content_io.read(GROUP_BYTE_COUNT).unpack("C").first
          else
            nil
          end
        end

        def decompressed_size
          if compressed?
            raw_content_io.rewind
            raw_content_io.read(DECOMPRESSED_SIZE_BYTE_COUNT).unpack("N").first
          else
            raw_content_io.size
          end
        end

        def preserve_on_file_alteration?
          frame_flags.preserve_on_file_alteration?
        end

        def preserve_on_tag_alteration?
          frame_flags.preserve_on_tag_alteration?
        end

        def read_only?
          frame_flags.read_only?
        end

        def compressed?
          frame_flags.compressed?
        end

        def encrypted?
          frame_flags.encrypted?
        end

        def grouped?
          frame_flags.grouped?
        end

        def unsynchronised?
          frame_flags.unsynchronised?
        end

        def data_length_indicator?
          frame_flags.data_length_indicator?
        end

        def additional_info_byte_count
          frame_flags.additional_info_byte_count
        end

        def inspect
          "<#{self.class.name} #{id}: #{inspect_content}>"
        end

        private

        def frame_flags
          @frame_flags ||= FrameFlags.new(@flags, @major_version_number)
        end

        def raw_content_io
          @raw_content_io ||= StringIO.new(raw_content)
        end

        def inspect_content
          content
        end
      end
    end
  end
end
