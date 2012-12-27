module ID3Tag
  class AudioFile
    ID3V1_TAG_SIZE = 128
    ID3V2_TAG_HEADER_SIZE = 10
    IDV1_TAG_IDENTIFIER = "TAG"
    IDV2_TAG_IDENTIFIER = "ID3"

    def initialize(file)
      @file = file
    end

    def v1_tag_present?
      @file.seek(-ID3V1_TAG_SIZE, IO::SEEK_END)
      @file.read(3) == IDV1_TAG_IDENTIFIER
    end

    def v2_tag_present?
      @file.rewind
      @file.read(3) == IDV2_TAG_IDENTIFIER
    end

    def v1_tag_body
      @file.seek(-ID3V1_TAG_SIZE + IDV1_TAG_IDENTIFIER.size, IO::SEEK_END)
      @file.read
    end
  end
end
