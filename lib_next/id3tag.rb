# frozen_string_literal: true

require "stringio"

module ID3Tag
  require_relative "id3tag/synchsafe_integer"
  require_relative "id3tag/byte_reader"
  require_relative "id3tag/number_util"
  require_relative "id3tag/unsynchronization"
end
