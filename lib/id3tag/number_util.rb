module ID3Tag
  module NumberUtil
    FORMAT_FOR_8_BIT_SIGNED_INTEGER = 'c'
    FORMAT_FOR_32BIT_INTEGER = 'N'
    def self.convert_string_to_32bit_integer(string)
      integers = string.unpack(FORMAT_FOR_32BIT_INTEGER)
      integers.first || raise(ArgumentError, "String: '#{string}' could not be decoded as 32-bit integer")
    end

    def self.convert_32bit_integer_to_string(integer)
      [integer].pack(FORMAT_FOR_32BIT_INTEGER)
    end
  end
end
