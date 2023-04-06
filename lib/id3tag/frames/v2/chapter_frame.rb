module ID3Tag
  module Frames
    module V2
      class ChapterFrame < BasicFrame
        def element_id
          @element_id ||= StringUtil.split_by_null_byte(raw_content).first
        end

        def start_time
          @start_time ||= parts[:start_time].unpack1("N")
        end

        def end_time
          @end_time ||= parts[:end_time].unpack1("N")
        end

        def start_offset
          @start_offset ||= parts[:start_offset].unpack1("N")
        end

        def end_offset
          @end_offset ||= parts[:end_offset].unpack1("N")
        end

        def subframes
          @subframes ||= parts[:subframes]
        end

        private

        def parts
          @parts ||= read_parts!
        end

        def read_parts!
          parts = {}
          raw_content_io.seek(element_id.size + 1)
          parts[:start_time] = raw_content_io.read(4)
          parts[:end_time] = raw_content_io.read(4)
          parts[:start_offset] = raw_content_io.read(4)
          parts[:end_offset] = raw_content_io.read(4)
          parts[:subframes] = ID3V2FrameParser.new(raw_content[raw_content_io.pos..], @major_version_number).frames
          parts
        end
      end
    end
  end
end
