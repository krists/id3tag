module ID3Tag
  class Tag
    class MultipleFrameError < StandardError; end
    COMMON_FRAME_IDS_BY_VERSION = {
      'v1.x' => {
        :artist => :artist,
        :title => :title,
        :album => :album,
        :year => :year,
        :comments => :comments,
        :genre => :genre,
        :track_nr => :track_nr
      },
      'v2.2' => {
        :artist => :TP1,
        :title => :TT2,
        :album => :TAL,
        :year => :TYE,
        :comments => :COM,
        :genre => :TCO,
        :track_nr => :TRK
      },
      'v2.3' => {
        :artist => :TPE1,
        :title => :TIT2,
        :album => :TALB,
        :year => :TYER,
        :comments => :COMM,
        :genre => :TCON,
        :track_nr => :TRCK
      },
      'v2.4' => {
        :artist => :TPE1,
        :title => :TIT2,
        :album => :TALB,
        :year => :TDRC,
        :comments => :COMM,
        :genre => :TCON,
        :track_nr => :TRCK
      }
    }

    class << self
      def read(source)
        new(source)
      end
    end

    def initialize(source)
      @source = source
    end

    def artist
      get_frame_content(frame_name(:artist))
    end

    def title
      get_frame_content(frame_name(:title))
    end

    def album
      get_frame_content(frame_name(:album))
    end

    def year
      get_frame_content(frame_name(:year))
    end

    def comments(language = nil)
      all_comments_frames = get_frames(frame_name(:comments))
      comments_frame = if language
        all_comments_frames.select { |frame| frame.language == language.to_s.downcase }.first
      else
        in_english = all_comments_frames.select { |frame| frame.language == 'eng' }
        in_english.first || all_comments_frames.first
      end
      comments_frame && comments_frame.content
    end

    def track_nr
      get_frame_content(frame_name(:track_nr))
    end

    def genre
      get_frame_content(frame_name(:genre))
    end

    def get_frame(frame_id)
      frames = get_frames(frame_id)
      if frames.count > 1
        raise MultipleFrameError, "Could not return only one frame with id: #{frame_id}. Tag has #{frames.count} of them"
      else
        frames.first
      end
    end

    def get_frames(frame_id)
      frames.select { |frame| frame.id == frame_id }
    end

    def frame_ids
      frames.map { |frame| frame.id }
    end

    def frames
      @frames ||= read_frames
    end

    private

    def get_frame_content(frame_id)
      frame = get_frame(frame_id)
      frame && frame.content
    end

    def frame_name(id)
      if audio_file.v2_tag_present?
        COMMON_FRAME_IDS_BY_VERSION["v2.#{audio_file.v2_tag_major_version_number}"][id]
      elsif audio_file.v1_tag_present?
        COMMON_FRAME_IDS_BY_VERSION["v1.x"][id]
      else
        nil
      end
    end

    def read_frames
      if audio_file.v2_tag_present?
        ID3V2FrameParser.new(audio_file.v2_tag_body, audio_file.v2_tag_major_version_number).frames
      elsif audio_file.v1_tag_present?
        ID3V1FrameParser.new(audio_file.v1_tag_body).frames
      else
        []
      end
    end

    def audio_file
      @audio_file ||= AudioFile.new(@source)
    end
  end
end
