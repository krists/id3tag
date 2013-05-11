module ID3Tag
  module StringUtil
    def self.blank?(string)
      string !~ /[^[:space:]]/
    end

    def self.do_unsynchronization(input)
      output_bytes = []
      input_bytes = input.unpack("C*").to_enum
      loop do
        current_byte = input_bytes.next
        output_bytes << current_byte
        next_byte = input_bytes.peek
        if (current_byte == 255) && (next_byte > 224)
          output_bytes << 0
        end
      end
      output_bytes.pack("C*").force_encoding(input.encoding)
    end

    def self.undo_unsynchronization(input)
      output_bytes = []
      input_bytes = input.unpack("C*").to_enum
      prev_byte = nil
      loop do
        current_byte = input_bytes.next
        next_byte = input_bytes.peek rescue 0
        unless (prev_byte == 255) && (current_byte == 0) && (next_byte > 224)
          output_bytes << current_byte
        end
        prev_byte = current_byte
      end
      output_bytes.pack("C*").force_encoding(input.encoding)
    end
  end
end
