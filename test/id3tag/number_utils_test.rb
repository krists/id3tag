# frozen_string_literal: true

require "test_helper"

module ID3Tag
  class NumberUtilTest < Minitest::Test
    using NumberUtil

    def test_x
      assert_equal 1, "\x00\x00\x00\x01".to_32bit_int
      assert_equal 1633837924, "abcd".to_32bit_int
    end

    def test_to_32bit_int_with_invalid_value
      assert_raises ArgumentError, "String \"\x00\x01\" could not be decoded as 32-bit integer" do
        "\x00\x01".to_32bit_int
      end
    end

    def test_to_32bit_int_with_valid_values
      assert_equal "\x00\x00\x01\xC8", 456.reverse_to_32bit_int
      assert_equal "abcd", 1633837924.reverse_to_32bit_int
    end

    def test_reverse_with_negative_integer
      assert_raises ArgumentError, "Integer cannot be negative" do
        (-1).reverse_to_32bit_int
      end
    end

    def test_reverse_with_too_large_integer
      assert_raises ArgumentError, "Integer to large" do
        4294967296.reverse_to_32bit_int
      end
    end

    def test_reverse_with_valid_integer_values
      assert_equal "\x00\x00\x00\x00",  0.reverse_to_32bit_int
      assert_equal "\x00\x00\x00a",  97.reverse_to_32bit_int
      assert_equal "\xFF\xFF\xFF\xFF",  4294967295.reverse_to_32bit_int
    end
  end
end