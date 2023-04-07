module ID3Tag
  module Frames
    module V2
      class TableOfContentsFrame < BasicFrame
        FLAG_A_TOP_LEVEL_BIT = "00000001".to_i(2)
        FLAG_B_ORDERED_BIT = "00000010".to_i(2)

        def element_id
          @element_id ||= StringUtil.split_by_null_byte(raw_content).first
        end

        def flags
          parts[:flags].unpack1("C")
        end

        def top_level?
          flags & FLAG_A_TOP_LEVEL_BIT > 0
        end

        def ordered?
          flags & FLAG_B_ORDERED_BIT > 0
        end

        def entry_count
          @entry_count ||= parts[:entry_count].unpack1("C")
        end

        def child_element_ids
          @child_element_ids ||= parts[:child_element_ids]
        end

        private

        def parts
          @parts ||= read_parts!
        end

        def read_parts!
          parts = {}
          raw_content_io.seek(element_id.size + 1)
          parts[:flags] = raw_content_io.read(1)
          parts[:entry_count] = raw_content_io.read(1)
          parts[:child_element_ids] = StringUtil.split_by_null_bytes(raw_content[raw_content_io.pos..])
          parts
        end
      end
    end
  end
end
