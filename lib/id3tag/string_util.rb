module ID3Tag
  module StringUtil
    def self.blank?(string)
      string !~ /[^[:space:]]/
    end
  end
end
