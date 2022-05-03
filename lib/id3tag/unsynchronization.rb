module ID3Tag
  class Unsynchronization
    def initialize(input)
      @input = input
      @encoding = input.encoding
    end

    def apply
      loop do
        current_byte = input_bytes.next
        output_bytes << current_byte
        next_byte = input_bytes.peek
        if (current_byte == 255) && ((next_byte >= 224) || (next_byte == 0))
          output_bytes << 0
        end
      end
    end

    def remove
      prev_byte = nil
      loop do
        current_byte = input_bytes.next
        next_byte = input_bytes.peek rescue nil
        unless (prev_byte == 255) && (current_byte == 0) && (next_byte != nil) && ((next_byte >= 224) || (next_byte == 0))
          output_bytes << current_byte
        end
        prev_byte = current_byte
      end
    end

    def output
      output_bytes.pack("C*").force_encoding(@encoding)
    end

    private

    def input_bytes
      @input_bytes ||= @input.unpack("C*").to_enum
    end

    def output_bytes
      @output_bytes ||= []
    end
  end
end
