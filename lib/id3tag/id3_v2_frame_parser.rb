module ID3Tag
  class ID3V2FrameParser
    def initialize(input, major_version_number)
      @input, @major_version_number = StringIO.new(input), major_version_number
    end

    def frames
      @frames ||= get_frames
    end

    private

    def get_frames
      frames = []
      rewind_input
      catch(:unexpected_eof) do
        loop do
          frame_id = read_next_frame_id
          frame_size = read_next_frame_size
          frame_flags = read_next_frame_flags
          frame_content = read_next_bytes(frame_size)
          frames << Frames::V2::FrameFabricator.fabricate(frame_id, frame_content, frame_flags, @major_version_number)
          break if padding_or_eof_reached?
        end
      end
      frames
    end

    def read_next_frame_id
      read_next_bytes(frame_id_length)
    end

    def read_next_frame_size
      case @major_version_number
      when 4
        SynchsafeInteger.decode(NumberUtil.convert_string_to_32bit_integer(read_next_bytes(4)))
      when 3
        NumberUtil.convert_string_to_32bit_integer(read_next_bytes(4))
      when 2
        NumberUtil.convert_string_to_32bit_integer("\x00" + read_next_bytes(3))
      end
    end

    def read_next_frame_flags
      frames_has_flags? ? read_next_bytes(2) : nil
    end

    def frame_id_length
      @major_version_number <= 2 ? 3 : 4
    end

    def frames_has_flags?
      @major_version_number > 2
    end

    def read_next_bytes(limit)
      bytes = @input.read(limit)
      throw(:unexpected_eof) unless bytes && bytes.bytesize == limit
      bytes
    end

    def rewind_input
      @input.rewind
    end

    def padding_or_eof_reached?
      current_position = @input.pos
      next_byte = @input.getbyte
      @input.pos = current_position
      (next_byte == 0) || @input.eof?
    end
  end
end
