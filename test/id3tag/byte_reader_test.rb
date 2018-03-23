# frozen_string_literal: true

require "test_helper"

module ID3Tag
  class ByteReaderTest < Minitest::Test
    using ByteReader

    def test_read_until_terminator_with_string_with_single_null_byte
      assert_equal "abc", StringIO.new("abc\x00def").read_until_terminator
    end

    def test_read_until_terminator_with_string_with_double_null_byte
      assert_equal "abc\x00de", StringIO.new("abc\x00de\x00\x00f").read_until_terminator(size: 2)
    end

    def test_with_string_without_terminator
      assert_equal "abcdef", StringIO.new("abcdef").read_until_terminator
    end

    def test_with_file
      file = Tempfile.new("id3tag_reader_test")
      File.open(file.path, "w+") do |f|
        f.write "abc\x00def\x00gh"
      end
      read_handle = File.open(file, "r")
      assert_equal "abc", read_handle.read_until_terminator
      assert_equal "def", read_handle.read_until_terminator
      assert_equal "gh",  read_handle.read_until_terminator
      assert_equal "",    read_handle.read_until_terminator
      read_handle.close
    ensure
      file.unlink
    end
  end
end