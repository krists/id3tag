module ID3Tag
  module StringUtil
    NULL_BYTE = "\x00"

    def self.blank?(string)
      string !~ /[^[:space:]]/
    end

    def self.do_unsynchronization(input)
      unsynch = Unsynchronization.new(input)
      unsynch.apply
      unsynch.output
    end

    def self.undo_unsynchronization(input)
      unsynch = Unsynchronization.new(input)
      unsynch.remove
      unsynch.output
    end

    def self.cut_at_null_byte(string)
      string.split(NULL_BYTE, 2).first
    end
  end
end
