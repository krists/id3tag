module ID3Tag
  module IOUtil

    def self.read_until_terminator(io, group_size)
      result = []
      bytes = io.each_byte
      current_group = bytes.take(group_size)
      while current_group.size == group_size do
        break if current_group.all? { |byte| byte == 0 }
        result += current_group
        current_group = bytes.take(group_size)
      end
      result.pack("C*")
    end

  end
end
