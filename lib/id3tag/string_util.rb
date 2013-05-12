module ID3Tag
  module StringUtil
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
  end
end
