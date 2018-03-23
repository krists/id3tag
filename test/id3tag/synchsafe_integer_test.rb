# frozen_string_literal: true

require "test_helper"

module ID3Tag
  class SynchsafeIntegerTest < Minitest::Test
    def test_encode
      assert_equal 383, SynchsafeInteger.encode(255)
      assert_equal 5, SynchsafeInteger.encode(5)
      assert_equal 256, SynchsafeInteger.encode(128)
    end

    def test_decode
      assert_equal 255, SynchsafeInteger.decode(383)
      assert_equal 5, SynchsafeInteger.decode(5)
      assert_equal 128, SynchsafeInteger.decode(256)
    end
  end
end
