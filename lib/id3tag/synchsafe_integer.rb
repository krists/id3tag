module ID3Tag
  class SynchsafeInteger
    class << self
      def encode(int)
        mask = 0x7F
        while mask <= 0x7FFFFFFF do
          out = int & ~mask
          out = out << 1
          out = out | (int & mask)
          mask = ((mask + 1) << 8) - 1
          int = out
        end
        out
      end

      def decode(synchsafe_int)
        out = 0
        mask = 0x7F000000
        while mask > 0 do
          out = out >> 1
          out = out | (synchsafe_int & mask)
          mask = mask >> 8
        end
        out
      end
    end
  end
end
