module ID3Tag
  module SynchsafeInteger
    def encode(int)
      mask = 0x7F
      while mask <= 0x7FFFFFFF
        out = int & ~mask
        out = out << 1
        out |= (int & mask)
        mask = ((mask + 1) << 8) - 1
        int = out
      end
      out
    end

    def decode(synchsafe_int)
      out = 0
      mask = 0x7F000000
      while mask > 0
        out = out >> 1
        out |= (synchsafe_int & mask)
        mask = mask >> 8
      end
      out
    end

    module_function :encode, :decode
  end
end
