module ID3Tag
  class Tag
    class MultipleFrameError < StandardError; end
    EASY_TEXT_FRAME_ACCESSOR_MAP = {
      :title => :TIT2,
      :artist => :TPE1,
      :album => :TALB,
      :year => :TYER,
      :comment => :TCOM,
      :genre => :TCON,
      :track_nr => :TRCK
    }

    class << self
      def read(source)
        new(source)
      end
    end

    def initialize(source)
      @source = source
    end

    EASY_TEXT_FRAME_ACCESSOR_MAP.each_pair do |method_name, frame_id|
      define_method(method_name) { get_content_of_text_frame(frame_id) }
    end

    def get_content_of_text_frame(frame_id)
      frame = get_frame(frame_id)
      frame && frame.content
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
      all_frames.select { |frame| frame.id == frame_id }
    end

    def frame_ids
      all_frames.map { |frame| frame.id }
    end

    def all_frames
      @all_frames ||= get_all_frames
    end

    private

    def get_all_frames
      if audio_file.v2_tag_present?
        ID3V2FrameParser.new(audio_file.v2_tag_body).frames
      elsif audio_file.v1_tag_present?
        ID3V1FrameParser.new(audio_file.v1_tag_body).frames
      end
    end

    def audio_file
      @audio_file ||= AudioFile.new(@source)
    end
  end
end
