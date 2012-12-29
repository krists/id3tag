require "set"

module ID3Tag
  LIBRARY_PATH = File.join(File.dirname(__FILE__), 'id3tag')
  autoload :SynchsafeInteger, File.join(LIBRARY_PATH, 'synchsafe_integer')
  autoload :AudioFile, File.join(LIBRARY_PATH, 'audio_file')
  autoload :ID3v2TagHeader, File.join(LIBRARY_PATH, 'id3_v2_tag_header')
  autoload :NumberUtils, File.join(LIBRARY_PATH, 'number_utils')
  autoload :ID3V1FrameParser, File.join(LIBRARY_PATH, 'id3_v1_frame_parser')
  autoload :Genre, File.join(LIBRARY_PATH, 'genre')
  autoload :Tag, File.join(LIBRARY_PATH, 'tag')
  module Frames
    module V1
      autoload :TextFrame, File.join(LIBRARY_PATH, 'frames/v1/text_frame')
      autoload :GenreFrame, File.join(LIBRARY_PATH, 'frames/v1/genre_frame')
    end
  end
end
