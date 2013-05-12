module ID3Tag
  class Tag
    class MultipleFrameError < StandardError; end

    class << self
      def read(source, version = :all)
        new(source, version)
      end
    end

    def initialize(source, version = :all)
      @source, @version = source, version
    end

    def artist
      get_frame_content(frame_id(:v2, :artist), frame_id(:v1, :artist))
    end

    def title
      get_frame_content(frame_id(:v2, :title), frame_id(:v1, :title))
    end

    def album
      get_frame_content(frame_id(:v2, :album), frame_id(:v1, :album))
    end

    def year
      get_frame_content(frame_id(:v2, :year), frame_id(:v1, :year))
    end

    def track_nr
      get_frame_content(frame_id(:v2, :track_nr), frame_id(:v1, :track_nr))
    end

    def genre
      get_frame_content(frame_id(:v2, :genre), frame_id(:v1, :genre))
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
      @frames ||= v2_frames + v1_frames
    end

    def v2_frames
      if audio_file.v2_tag_present? && [:v2, :all].include?(@version)
        ID3V2FrameParser.new(audio_file.v2_tag_body, audio_file.v2_tag_major_version_number).frames
      else
        []
      end
    end

    def v1_frames
      if audio_file.v1_tag_present? && [:v1, :all].include?(@version)
        ID3V1FrameParser.new(audio_file.v1_tag_body).frames
      else
        []
      end
    end

    def get_frame_content(frame_id, *alt_frame_ids)
      frame = nil
      alt_frame_ids.unshift(frame_id).each do |frame_id|
        frame = get_frame(frame_id)
        break if frame
      end
      frame && frame.content
    end

    private

    def frame_id(version, name)
      case version
      when :v2
        if audio_file.v2_tag_present?
          FrameIdAdvisor.new(2, audio_file.v2_tag_major_version_number).advise(name)
        end
      when :v1
        FrameIdAdvisor.new(1, 'x').advise(name)
      else
        nil
      end
    end

    def audio_file
      @audio_file ||= AudioFile.new(@source)
    end
  end
end
