module ID3Tag
  module StringUtils
    def self.blank?(string)
      string !~ /[^[:space:]]/
    end
  end
end
