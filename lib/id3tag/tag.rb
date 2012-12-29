module ID3Tag
  class Tag
    EASY_TEXT_FRAME_ACCESSOR_MAP = {
      :title => :TIT2,
      :artist => :TPE1,
      :album => :TALB,
      :year => :TYER,
      :comment => :TCOM,
      :genre => :TCON
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
      define_method(method_name) { get_text_frame(frame_id) }
    end

    def frames
      @frames ||= get_frames
    end


    def get_text_frame(frame_id)
      frame = get_frame(frame_id)
      frame && frame.value
    end

    def frame_ids
      frames.map { |frame| frame.id }
    end

    def get_frame(frame_id)
      frames = get_frames(frame_id)
      if frames.count > 1
        raise "Tag has multiple text frames with the same id"
      else
        frames.first
      end
    end

    def get_frames(frame_id)
      frames.select { |frame| frame.id == frame_id }
    end

    private

    def get_frames
      if audio_file.v2_tag_present?
        raise "not implemented yet"
      elsif audio_file.v1_tag_present?
        ID3V1FrameParser.new(audio_file.v1_tag_body).frames
      end
    end

    def audio_file
      @audio_file ||= AudioFile.new(@source)
    end
  end
end
