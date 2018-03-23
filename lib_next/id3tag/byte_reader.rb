# frozen_string_literal: true

module ID3Tag
  module ByteReader
    module UntilTerminator
      def read_until_terminator(size: 1)
        result = []
        bytes = each_byte
        current = bytes.take(size)
        while current.size == size
          break if current.all? { |byte| byte == 0 }
          result += current
          current = bytes.take(size)
        end
        result.pack("C*")
      end
    end

    refine StringIO do
      include UntilTerminator
    end

    refine IO do
      include UntilTerminator
    end
  end
end