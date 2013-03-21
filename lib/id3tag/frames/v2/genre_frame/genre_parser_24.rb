module ID3Tag
  module Frames
    module  V2
      class GenreFrame
        class GenreParser24 < GenreParser
          def genres
            genre_string.split("\x00").map do |genre|
              expand_abbreviation(genre)
            end
          end
        end
      end
    end
  end
end
