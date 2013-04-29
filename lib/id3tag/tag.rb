module ID3Tag
  class Tag
    class MultipleFrameError < StandardError; end

    class << self
      def read(source, version = nil)
        new(source, version)
      end
    end

    def initialize(source, version = nil)
      @source, @version = source, version
    end

    def artist
      get_frame_content(frame_id_by_name(:artist))
    end

    def title
      get_frame_content(frame_id_by_name(:title))
    end

    def album
      get_frame_content(frame_id_by_name(:album))
    end

    def year
      get_frame_content(frame_id_by_name(:year))
    end

    def comments(language = nil)
      all_comments_frames = get_frames(frame_id_by_name(:comments))
      comments_frame = if language
        all_comments_frames.select { |frame| frame.language == language.to_s.downcase }.first
      else
        in_english = all_comments_frames.select { |frame| frame.language == 'eng' }
        in_english.first || all_comments_frames.first
      end
      comments_frame && comments_frame.content
    end

    def track_nr
      get_frame_content(frame_id_by_name(:track_nr))
    end

    def genre
      get_frame_content(frame_id_by_name(:genre))
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
      @frames ||= parse_frames
    end

    def get_frame_content(frame_id)
      frame = get_frame(frame_id)
      frame && frame.content
    end

    def parsable_version
      @parsable_version ||= calc_parsable_version
    end

    private

    def frame_id_by_name(name)
      case parsable_version
      when 2
        FrameIdAdvisor.new(2, audio_file.v2_tag_major_version_number).advise(name)
      when 1
        FrameIdAdvisor.new(1, 'x').advise(name)
      else
        nil
      end
    end

    def parse_frames
      case parsable_version
      when 2
        ID3V2FrameParser.new(audio_file.v2_tag_body, audio_file.v2_tag_major_version_number).frames
      when 1
        ID3V1FrameParser.new(audio_file.v1_tag_body).frames
      else
        []
      end
    end

    def calc_parsable_version
      if @version
        method = "v#{@version}_tag_present?"
        if audio_file.respond_to?(method) && audio_file.send(method)
          @version
        else
          nil
        end
      else
        audio_file.greatest_tag_version
      end
    end

    def audio_file
      @audio_file ||= AudioFile.new(@source)
    end
  end
end
