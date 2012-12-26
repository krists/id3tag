module ID3Tag
  LIBRARY_PATH = File.join(File.dirname(__FILE__), 'id3tag')
  autoload :SynchsafeInteger, File.join(LIBRARY_PATH, 'synchsafe_integer')
end
