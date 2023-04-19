module ID3Tag
  module Frames
    module V2
      class TableOfContentsFrame < BasicFrame
        FLAG_A_TOP_LEVEL_BIT = "00000001".to_i(2)
        FLAG_B_ORDERED_BIT = "00000010".to_i(2)

        def element_id
          unpacked[:element_id]
        end

        def top_level?
          unpacked[:flags] & FLAG_A_TOP_LEVEL_BIT > 0
        end

        def ordered?
          unpacked[:flags] & FLAG_B_ORDERED_BIT > 0
        end

        def entry_count
          unpacked[:entry_count]
        end

        def child_element_ids
          unpacked[:child_element_ids]
        end

        alias_method :content, :child_element_ids
        alias_method :inspectable_content, :content

        def subframes
          unpacked[:subframes]
        end

        private

        def unpacked
          return @unpacked if defined?(@unpacked)
          @unpacked = {}
          raw_content_io.rewind
          @unpacked[:element_id] = IOUtil.read_until_terminator(raw_content_io, 1)
          @unpacked[:flags] = raw_content_io.read(1).unpack1("C")
          @unpacked[:entry_count] = raw_content_io.read(1).unpack1("C")

          @unpacked[:child_element_ids] = []
          current_entry = 0
          while current_entry < @unpacked[:entry_count]
            @unpacked[:child_element_ids].push(IOUtil.read_until_terminator(raw_content_io, 1))
            current_entry += 1
          end

          @unpacked[:subframes] = ID3V2FrameParser.new(raw_content_io.read, @major_version_number).frames

          @unpacked
        end
      end
    end
  end
end
