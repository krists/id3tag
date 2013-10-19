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
          usable_content
        end

        def usable_content
          raw_content_io.seek(additional_info_byte_count)
          if unsynchronised?
            StringUtil.undo_unsynchronization(raw_content_io.read)
          else
            raw_content_io.read
          end
        end

        def group_id
          pos, count = position_and_count_of_group_id_bytes
          if grouped? && pos && count
            raw_content_io.seek(pos)
            raw_content_io.read(count).unpack("C").first
          else
            nil
          end
        end

        def encryption_id
          pos, count = position_and_count_of_encryption_id_bytes
          if encrypted? && pos && count
            raw_content_io.seek(pos)
            raw_content_io.read(count).unpack("C").first
          else
            nil
          end
        end

        def final_size
          pos, count = position_and_count_of_data_length_bytes
          if (compressed? || data_length_indicator?) && pos && count
            raw_content_io.seek(pos)
            raw_content_io.read(count).unpack("N").first
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

        def inspect
          "<#{self.class.name} #{id}: #{inspect_content}>"
        end

        private

        def additional_info_byte_count
          frame_flags.additional_info_byte_count
        end

        def position_and_count_of_data_length_bytes
          frame_flags.position_and_count_of_data_length_bytes
        end

        def position_and_count_of_group_id_bytes
          frame_flags.position_and_count_of_group_id_bytes
        end

        def position_and_count_of_encryption_id_bytes
          frame_flags.position_and_count_of_encryption_id_bytes
        end

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
