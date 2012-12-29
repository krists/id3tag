module ID3Tag
  class ID3v2TagHeader
    def initialize(header_chunk)
      @content = StringIO.new(header_chunk)
    end

    def major_version_number
      @content.seek(3)
      @content.readbyte
    end

    def minor_version_number
      @content.seek(4)
      @content.readbyte
    end

    def unsynchronisation?
      flags_byte[7] == 1
    end

    def extended_header?
      flags_byte[6] == 1
    end

    def experimental?
      flags_byte[5] == 1
    end

    def footer_present?
      flags_byte[4] == 1
    end

    def tag_size
      @tag_size ||= get_tag_size
    end

    private

    def flags_byte
      @flags_byte ||= get_flags_byte
    end

    def get_flags_byte
      @content.seek(5)
      @content.readbyte
    end

    def get_tag_size
      SynchsafeInteger.decode(NumberUtils.convert_string_to_32bit_integer(tag_size_bytes))
    end

    def tag_size_bytes
      @content.seek(6)
      @content.read(4)
    end
  end
end
