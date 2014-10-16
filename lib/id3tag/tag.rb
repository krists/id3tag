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

    [:artist, :title, :album, :year, :track_nr, :genre].each do |name|
      define_method(name) do
        content_of_first_frame(name)
      end
    end

    def content_of_first_frame(name)
      possible_frame_ids_by_name(name).each do |frame_id|
        first_frame_by_id(frame_id).try do |frame|
          return frame.content unless frame.content.strip.empty?
        end
      end
      nil
    end

    [:comments, :unsychronized_transcription].each do |name|
      define_method(name) do |lang = :eng|
        content_of_first_frame_with_language(name, lang)
      end
    end

    def content_of_first_frame_with_language(name, lang)
      frame = all_frames_by_id(*possible_frame_ids_by_name(name)).find { |x| x.language == lang.to_s }
      frame && frame.content
    end

    def first_frame_by_id(*ids)
      first_existing_id = ids.find { |id| frame_ids.include?(id) }
      first_existing_id && get_frame(first_existing_id)
    end

    def all_frames_by_id(*ids)
      ids.inject([]) do |frames, id|
        frames += get_frames(id)
      end
    end

    def get_frame(frame_id)
      frames = get_frames(frame_id)
      if frames.count > 1
        raise MultipleFrameError, "Could not return only one frame with id: #{frame_id}. Tag has #{frames.count} of them. Try #get_frames to get all of them"
      else
        frames.first
      end
    end

    def get_frames(frame_id)
      frames.select { |frame| frame.id == frame_id }
    end

    def frame_ids
      @frame_ids ||= frames.map { |frame| frame.id }
    end

    def frames
      @frames ||= v2_frames + v1_frames
    end

    def v2_frames
      if should_and_could_read_v2_frames?
        ID3V2FrameParser.new(audio_file.v2_tag_body, audio_file.v2_tag_major_version_number).frames
      else
        []
      end
    end

    def v1_frames
      if should_and_could_read_v1_frames?
        ID3V1FrameParser.new(audio_file.v1_tag_body).frames
      else
        []
      end
    end

    def audio_file
      @audio_file ||= AudioFile.new(@source)
    end

    private

    def possible_frame_ids_by_name(name)
      ids = []
      id = possible_v2_frame_id_by_name(name)
      ids << id if id
      id = possible_v1_frame_id_by_name(name)
      ids << id if id
      ids
    end

    def possible_v2_frame_id_by_name(name)
      if should_and_could_read_v2_frames?
        FrameIdAdvisor.new(2, audio_file.v2_tag_major_version_number).advise(name)
      end
    end

    def possible_v1_frame_id_by_name(name)
      if should_and_could_read_v1_frames?
        FrameIdAdvisor.new(1, FrameIdAdvisor::ANY_MAJOR_VERSION).advise(name)
      end
    end

    def should_and_could_read_v1_frames?
      scope.include?(:v1) && audio_file.v1_tag_present?
    end

    def should_and_could_read_v2_frames?
      scope.include?(:v2) && audio_file.v2_tag_present?
    end
  end
end
