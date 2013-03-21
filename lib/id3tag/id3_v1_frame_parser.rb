module ID3Tag
  class ID3V1FrameParser

    def initialize(input)
      @input = StringIO.new(input)
    end

    def frames
      @frames ||= get_frames
    end

    private

    def get_frames
      frames = Set.new
      frames << title_frame
      frames << artist_frame
      frames << album_frame
      frames << year_frame
      frames << comment_frame
      frames << genre_frame
      frames << track_nr_frame if tag_version_1_1?
      frames
    end

    def title_frame
      Frames::V1::TextFrame.new(:title, read_from_pos_till_null_byte_or_limit(0, 30))
    end

    def artist_frame
      Frames::V1::TextFrame.new(:artist, read_from_pos_till_null_byte_or_limit(30, 30))
    end

    def album_frame
      Frames::V1::TextFrame.new(:album, read_from_pos_till_null_byte_or_limit(60, 30))
    end

    def year_frame
      Frames::V1::TextFrame.new(:year, read_from_pos_till_null_byte_or_limit(90, 4))
    end

    def comment_frame
      Frames::V1::CommentsFrame.new(:comments, read_from_pos_till_null_byte_or_limit(94, comment_frame_size))
    end

    def genre_frame
      Frames::V1::GenreFrame.new(:genre, read_from_pos_till_limit(124, 1))
    end

    def track_nr_frame
      Frames::V1::TrackNrFrame.new(:track_nr, read_from_pos_till_null_byte_or_limit(123, 1))
    end

    def comment_frame_size
      if tag_version_1_1?
        28
      else
        30
      end
    end

    def tag_version_1_1?
      @tag_version_1_1 ||= get_tag_version_1_1?
    end

    def get_tag_version_1_1?
      second_last_comment_byte, last_comment_byte = read_from_pos_till_limit(122, 2).bytes.to_a
      (second_last_comment_byte == 0) && (last_comment_byte != 0)
    end

    def read_from_pos_till_null_byte_or_limit(position, limit)
      @input.seek(position)
      value = ""
      limit.times do
        char = @input.getc
        break if char == "\x00"
        value << char
      end
      value
    end

    def read_from_pos_till_limit(position, limit)
      @input.seek(position)
      @input.read(limit)
    end
  end
end
