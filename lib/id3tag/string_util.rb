module ID3Tag
  module StringUtil
    NULL_BYTE = "\x00"
    UTF_8_DIRECTIVE = "U*"

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
      string.split(NULL_BYTE, 2).first.to_s
    end

    def self.split_by_null_byte(string)
      null_byte_found = false
      has_skipped = false
      before, after = [], []
      string.each_byte do |byte|
        if byte == 0
          null_byte_found = true
          (has_skipped = true) and next unless has_skipped
        end
        if null_byte_found
          after << byte
        else
          before << byte
        end
      end
      [before.pack(UTF_8_DIRECTIVE), after.pack(UTF_8_DIRECTIVE)]
    end

    def self.split_by_null_bytes(string)
      string.split(NULL_BYTE)
    end

    def self.chomp_null_byte(string)
      string.chomp(NULL_BYTE)
    end
  end
end
