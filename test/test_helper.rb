# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../lib_next", __FILE__)
require "pry"
require "id3tag"
require "minitest/autorun"

module ConfigurationSetter
end

class Minitest::Test
  include ConfigurationSetter
end
