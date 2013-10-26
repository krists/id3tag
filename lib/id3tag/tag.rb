module ID3Tag
  class Tag
    MultipleFrameError =  Class.new(StandardError)

    class << self
      def read(source, scope = :all)
        new(source, scope)
      end
    end

    def initialize(source, scope = :all)
      @source, @scope = source, Scope.new(scope)
    end

    attr_reader :source, :scope

    [:artist, :title, :album, :year, :track_nr, :genre, :comments, :unsychronized_transcription].each do |name|
      define_method(name) do
        get_content_of_first_find_by_name(name)
      end
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
      if audio_file.v2_tag_present? && scope.include?(:v2)
        ID3V2FrameParser.new(audio_file.v2_tag_body, audio_file.v2_tag_major_version_number).frames
      else
        []
      end
    end

    def v1_frames
      if audio_file.v1_tag_present? && scope.include?(:v1)
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

    def get_content_of_first_find_by_name(name)
      frame = nil
      possible_frame_ids_by_name(name).each do |id|
        frame = get_frame(id)
        break if frame
      end
      frame && frame.content
    end

    def possible_frame_ids_by_name(name)
      ids = []
      if scope.include?(:v2) && audio_file.v2_tag_present?
        id = FrameIdAdvisor.new(2, audio_file.v2_tag_major_version_number).advise(name)
        ids << id if id
      end
      if scope.include?(:v1) && audio_file.v1_tag_present?
        id = FrameIdAdvisor.new(1, FrameIdAdvisor::ANY_MAJOR_VERSION).advise(name)
        ids << id if id
      end
      ids
    end

    def audio_file
      @audio_file ||= AudioFile.new(@source)
    end
  end
end
