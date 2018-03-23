# frozen_string_literal: true

module ID3Tag
  module Unsynchronization
    
    refine String do
      def apply_unsynchronization
        output_bytes = []
        bytes = each_byte
        loop do
          current_byte = bytes.next
          output_bytes << current_byte
          next_byte = bytes.peek
          if (current_byte == 255) && (next_byte > 224)
            output_bytes << 0
          end
        end
        output_bytes.pack("C*").force_encoding(encoding)
      end

      def remove_unsynchronization
        bytes = each_byte
        output_bytes = []
        prev_byte = nil
        loop do
          current_byte = bytes.next
          next_byte = bytes.peek rescue 0
          unless (prev_byte == 255) && (current_byte == 0) && (next_byte > 224)
            output_bytes << current_byte
          end
          prev_byte = current_byte
        end
        output_bytes.pack("C*").force_encoding(encoding)
      end
    end
  end
end
