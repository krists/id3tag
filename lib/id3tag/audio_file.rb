module ID3Tag
  class AudioFile
    ID3V1_TAG_SIZE = 128
    ID3V2_TAG_HEADER_SIZE = 10
    IDV1_TAG_IDENTIFIER = "TAG"
    IDV2_TAG_IDENTIFIER = "ID3"

    def initialize(file)
      @file = file
    end

    def v1_tag_present?
      @file.seek(-ID3V1_TAG_SIZE, IO::SEEK_END)
      @file.read(3) == IDV1_TAG_IDENTIFIER
    end

    def v2_tag_present?
      @file.rewind
      @file.read(3) == IDV2_TAG_IDENTIFIER
    end

    def v1_tag_body
      @file.seek(-ID3V1_TAG_SIZE + IDV1_TAG_IDENTIFIER.size, IO::SEEK_END)
      @file.read
    end

    def v2_tag_body
      @file.seek(v2_tag_frame_and_padding_position)
      @file.read(v2_tag_frame_and_padding_size)
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
        SynchsafeInteger.decode(NumberUtil.convert_string_to_32bit_integer(v2_extended_header_size_bytes))
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
      @file.rewind
      ID3v2TagHeader.new(@file.read(ID3V2_TAG_HEADER_SIZE))
    end
  end
end
