module ID3Tag
  module IOUtil
    class Result

      def initialize
        @terminator_reached = false
      end

      attr_accessor :start_pos, :end_pos, :null_byte_count, :terminator_reached

      def byte_count_before_terminator
        if terminator_reached
          end_pos - start_pos - null_byte_count
        else
          end_pos - start_pos
        end
      end

      def byte_count_of_content_and_terminator
        end_pos - start_pos
      end
    end

    def self.find_terminator(io, terminator_byte_count)
      case terminator_byte_count
      when 1
        find_null_byte(io)
      when 2
        find_two_null_bytes(io)
      else
        raise ArgumentError.new('Terminator byte count not supported')
      end
    end

    def self.find_null_byte(io)
      result = Result.new
      result.null_byte_count = 1
      result.start_pos = io.pos
      io.each_byte do |byte|
        if byte == 0
          result.terminator_reached = true
          break
        end
      end
      result.end_pos = io.pos
      io.seek(result.start_pos)
      result
    end

    def self.find_two_null_bytes(io)
      result = Result.new
      result.null_byte_count = 2
      result.start_pos = io.pos
      memory = nil
      io.each_byte do |byte|
        if (byte == 0) && (memory == 0)
          result.terminator_reached = true
          break
        end
        memory = byte
      end
      result.end_pos = io.pos
      io.seek(result.start_pos)
      result
    end

    def self.maintain_original_position(io)
      start_pos = io.pos
      yield
      io.seek(start_pos)
    end
  end
end
