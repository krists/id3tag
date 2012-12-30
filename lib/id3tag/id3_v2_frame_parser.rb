module ID3Tag
  class ID3V2FrameParser
    def initialize(input)
      @input = StringIO.new(input)
    end

    def frames
      @frames ||= get_frames
    end

    private

    def get_frames
      []
    end
  end
end

