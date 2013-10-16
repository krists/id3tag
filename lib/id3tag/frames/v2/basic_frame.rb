module  ID3Tag
  module Frames
    module  V2
      class BasicFrame
        DECOMPRESSED_SIZE_BYTE_COUNT = 4
        GROUP_BYTE_COUNT = 1
        FrameNotCompressedError = Class.new(StandardError)

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

        def inspect
          "<#{self.class.name} #{id}: #{inspect_content}>"
        end

        def preserve_on_tag_alteration?
          if usable_status_byte_from_flags?
            status_byte_from_flags[7] == 0
          else
            true
          end
        end

        def preserve_on_file_alteration?
          if usable_status_byte_from_flags?
            status_byte_from_flags[6] == 0
          else
            true
          end
        end

        def read_only?
          if usable_status_byte_from_flags?
            status_byte_from_flags[5] == 1
          else
            false
          end
        end

        def compressed?
          if usable_encoding_byte_from_flags?
            encoding_byte_from_flags[7] == 1
          else
            false
          end
        end

        def encrypted?
          if usable_encoding_byte_from_flags?
            encoding_byte_from_flags[6] == 1
          else
            false
          end
        end

        def grouped?
          if usable_encoding_byte_from_flags?
            encoding_byte_from_flags[5] == 1
          else
            false
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

        private

        def raw_content_io
          @raw_content_io ||= StringIO.new(raw_content)
        end

        def usable_status_byte_from_flags?
          status_byte_from_flags.respond_to?(:[])
        end

        def usable_encoding_byte_from_flags?
          encoding_byte_from_flags.respond_to?(:[])
        end

        def status_byte_from_flags
          flags_byte_pair.first
        end

        def encoding_byte_from_flags
          flags_byte_pair.last
        end

        def flags_byte_pair
          @flags.to_s.unpack("C2")
        end

        def inspect_content
          content
        end
      end
    end
  end
end
