module ID3Tag
  module Frames
    module V2
      class ChapterFrame < BasicFrame
        def element_id
          unpacked[:element_id]
        end

        def start_time
          unpacked[:start_time]
        end

        def end_time
          unpacked[:end_time]
        end

        def start_offset
          unpacked[:start_offset]
        end

        def end_offset
          unpacked[:end_offset]
        end

        def subframes
          unpacked[:subframes]
        end

        alias_method :inspectable_content, :element_id

        private

        def unpacked
          return @unpacked if defined?(@unpacked)
          @unpacked = {}
          raw_content_io.rewind
          @unpacked[:element_id] = IOUtil.read_until_terminator(raw_content_io, 1)
          @unpacked[:start_time] = raw_content_io.read(4).unpack1("N")
          @unpacked[:end_time] = raw_content_io.read(4).unpack1("N")
          @unpacked[:start_offset] = raw_content_io.read(4).unpack1("N")
          @unpacked[:end_offset] = raw_content_io.read(4).unpack1("N")
          @unpacked[:subframes] = ID3V2FrameParser.new(raw_content_io.read, @major_version_number).frames
          @unpacked
        end
      end
    end
  end
end
