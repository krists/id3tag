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

    def version_number
      sprintf("%s.%s", major_version_number, minor_version_number)
    end

    def unsynchronisation?
      0b1000_0000 & flags_byte > 0
    end

    def extended_header?
      0b100_0000 & flags_byte > 0
    end

    def experimental?
      0b10_0000 & flags_byte > 0
    end

    def footer_present?
      0b1_0000 & flags_byte > 0
    end

    def tag_size
      @tag_size ||= get_tag_size
    end

    def inspect
      "<#{self.class.name} version:2.#{version_number} size:#{tag_size} unsync:#{unsynchronisation?} ext.header:#{extended_header?} experimental:#{experimental?} footer:#{footer_present?}>"
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
      SynchsafeInteger.decode(NumberUtil.convert_string_to_32bit_integer(tag_size_bytes))
    end

    def tag_size_bytes
      @content.seek(6)
      @content.read(4)
    end
  end
end
