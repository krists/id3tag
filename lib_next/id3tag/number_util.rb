# frozen_string_literal: true

module ID3Tag
  module NumberUtil
    FORMAT_FOR_32BIT_INTEGER = 'N'.freeze
    MAX_INTEGER_VALUE = 4294967295.freeze

    refine String do
      def to_32bit_int
        unpack(FORMAT_FOR_32BIT_INTEGER).first.tap do |value|
          raise(ArgumentError, "String #{self.inspect} could not be decoded as 32-bit integer") unless value
        end
      end
    end
    
    refine Integer do
      def reverse_to_32bit_int
        raise ArgumentError, "Integer cannot be negative" if self < 0
        raise ArgumentError, "Integer to large" if self > MAX_INTEGER_VALUE
        [self].pack(FORMAT_FOR_32BIT_INTEGER).force_encoding(Encoding::UTF_8)
      end
    end
  end
end
