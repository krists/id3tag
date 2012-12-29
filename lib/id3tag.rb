module ID3Tag
  LIBRARY_PATH = File.join(File.dirname(__FILE__), 'id3tag')
  autoload :SynchsafeInteger, File.join(LIBRARY_PATH, 'synchsafe_integer')
  autoload :AudioFile, File.join(LIBRARY_PATH, 'audio_file')
  autoload :ID3v2TagHeader, File.join(LIBRARY_PATH, 'id3_v2_tag_header')
  autoload :NumberUtils, File.join(LIBRARY_PATH, 'number_utils')
end
