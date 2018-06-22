module ID3Tag
  class AudioFile
    ID3V1_TAG_SIZE = 128
    ID3V2_TAG_HEADER_SIZE = 10
    IDV1_TAG_IDENTIFIER = "TAG"
    IDV2_TAG_IDENTIFIER = "ID3"
    BLANK_STRING = ""

    def initialize(file)
      @file = file
    end

    def v1_tag_present?
      if @file.size >= ID3V1_TAG_SIZE
        @file.seek(-ID3V1_TAG_SIZE, IO::SEEK_END)
        @file.read(3) == IDV1_TAG_IDENTIFIER
      else
        false
      end
    end

    def v2_tag_present?
      @file.seek(0)
      @file.read(3) == IDV2_TAG_IDENTIFIER
    end

    def v1_tag_body
      if v1_tag_present?
        @file.seek(-v1_tag_size, IO::SEEK_END)
        @file.read(v1_tag_size)
      else
        nil
      end
    end

    def v1_tag_size
      if v1_tag_present?
        ID3V1_TAG_SIZE - IDV1_TAG_IDENTIFIER.size
      else
        0
      end
    end

    def v2_tag_body
      if v2_tag_size > 0
        @file.seek(v2_tag_frame_and_padding_position)
        bytes_to_read = v2_tag_frame_and_padding_size
        limit = ID3Tag.configuration.v2_tag_read_limit
        if (limit > 0) && (bytes_to_read > limit)
          bytes_to_read = limit
        end
        @file.read(bytes_to_read) || BLANK_STRING
      end
    end

    def v2_tag_size
      if v2_tag_present?
        v2_tag_header.tag_size
      else
        0
      end
    end

    def v2_tag_version
      v2_tag_header.version_number
    end

    def v2_tag_major_version_number
      v2_tag_header.major_version_number
    end

    def v2_tag_minor_version_number
      v2_tag_header.minor_version_number
    end

    private

    def v2_tag_frame_and_padding_position
      ID3V2_TAG_HEADER_SIZE + v2_extended_header_size
    end

    def v2_tag_frame_and_padding_size
      v2_tag_header.tag_size - v2_extended_header_size
    end

    def v2_extended_header_size
      @v2_extended_header_size ||= get_v2_extended_header_size
    end

    def get_v2_extended_header_size
      if v2_tag_header.extended_header?
        if v2_tag_major_version_number == 3
          # ext. header size for 2.3.0 does not include size bytes.
          # There are only 2 possible sizes - 6 or 10 bytes, which means extended header can take 10 or 14 bytes.
          4 + NumberUtil.convert_string_to_32bit_integer(v2_extended_header_size_bytes)
        else
          SynchsafeInteger.decode(NumberUtil.convert_string_to_32bit_integer(v2_extended_header_size_bytes))
        end
      else
        0
      end
    end

    def v2_extended_header_size_bytes
      @file.seek(ID3V2_TAG_HEADER_SIZE)
      @file.read(4)
    end

    def v2_tag_header
      @v2_tag_header ||= get_v2_tag_header
    end

    def get_v2_tag_header
      @file.seek(0)
      ID3v2TagHeader.new(@file.read(ID3V2_TAG_HEADER_SIZE))
    end
  end
end
