# frozen_string_literal: true

require "test_helper"

class ID3TagTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ID3Tag::VERSION
  end
end
