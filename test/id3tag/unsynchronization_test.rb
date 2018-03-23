# frozen_string_literal: true

require "test_helper"

module ID3Tag
  class UnsynchronizationTest < Minitest::Test
    using Unsynchronization

    def test_apply_unsynchronization
      assert_equal "abc", "abc".apply_unsynchronization
      assert_equal "abc\xFF\x00\xFFef", "abc\xFF\xFFef".apply_unsynchronization
    end

    def test_remove_unsynchronization
      assert_equal "abc\xFF\xFF123", "abc\xFF\x00\xFF123".remove_unsynchronization
    end

    def test_apply_unsynchronization_encoding
      test_str = String.new("abc\xFF\xFFd", encoding: Encoding::UTF_16)
      assert_equal [97, 98, 99, 255, 255, 100], test_str.bytes
      applied = test_str.apply_unsynchronization
      assert_equal [97, 98, 99, 255, 0, 255, 100], applied.bytes
      assert_equal Encoding::UTF_16, applied.encoding
    end
  end
end
