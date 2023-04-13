require "stringio"
require "singleton"
require "id3tag/configuration_struct"
require "id3tag/configuration"
require "id3tag/synchsafe_integer"
require "id3tag/audio_file"
require "id3tag/id3_v2_tag_header"
require "id3tag/unsynchronization"
require "id3tag/number_util"
require "id3tag/string_util"
require "id3tag/encoding_util"
require "id3tag/io_util"
require "id3tag/id3_v1_frame_parser"
require "id3tag/id3_v2_frame_parser"
require "id3tag/frame_id_advisor"
require "id3tag/tag"
require "id3tag/scope"
require "id3tag/frames/util/genre_names"
require "id3tag/frames/v1/text_frame"
require "id3tag/frames/v1/genre_frame"
require "id3tag/frames/v1/comments_frame"
require "id3tag/frames/v1/track_nr_frame"
require "id3tag/frames/v2/basic_frame"
require "id3tag/frames/v2/text_frame"
require "id3tag/frames/v2/user_text_frame"
require "id3tag/frames/v2/url_frame"
require "id3tag/frames/v2/user_url_frame"
require "id3tag/frames/v2/involved_people_list_frame"
require "id3tag/frames/v2/unique_file_id_frame"
require "id3tag/frames/v2/private_frame"
require "id3tag/frames/v2/comments_frame"
require "id3tag/frames/v2/unsychronized_transcription_frame"
require "id3tag/frames/v2/picture_frame"
require "id3tag/frames/v2/genre_frame"
require "id3tag/frames/v2/chapter_frame"
require "id3tag/frames/v2/table_of_contents_frame"
require "id3tag/frames/v2/genre_frame/genre_parser"
require "id3tag/frames/v2/genre_frame/genre_parser_pre_24"
require "id3tag/frames/v2/genre_frame/genre_parser_24"
require "id3tag/frames/v2/frame_fabricator"
require "id3tag/frames/v2/frame_flags"

module ID3Tag
  def self.read(source, scope = :all)
    tag = Tag.read(source, scope)
    yield tag if block_given?
    tag
  end

  class << self
    def configuration(&blk)
      ID3Tag::Configuration.configuration(&blk)
    end

    def local_configuration(&blk)
      ID3Tag::Configuration.local_configuration(&blk)
    end

    def reset_configuration
      ID3Tag::Configuration.reset
    end
  end
end
