module ID3Tag
  class ID3v2TagHeader
    def initialize(header_chunk)
      @content = StringIO.new(header_chunk)
    end

    def major_version_number
      @content.seek(3, IO::SEEK_SET)
      @content.readbyte
    end

    def minor_version_number
      @content.seek(4, IO::SEEK_SET)
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
      @content.seek(5, IO::SEEK_SET)
      @content.readbyte
    end

    def get_tag_size
      @content.seek(6, IO::SEEK_SET)
      integers = @content.read(4).unpack('N') #TODO: Raise error if read less than 4 bytes
      SynchsafeInteger.decode(integers.first)
    end
  end
end
