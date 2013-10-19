module ID3Tag
  module Frames
    module  V2
      class GenreFrame < BasicFrame
        class MissingGenreParser < StandardError; end

        def genres
          @genres ||= get_genres
        end

        def content
          genres.join(", ")
        end

        private

        def get_genres
          genre_parser.new(usable_content).genres
        end

        def genre_parser
          case @major_version_number
          when 0...4
            GenreParserPre24
          when 4
            GenreParser24
          else
            raise(MissingGenreParser,"Missing genre parser for tag version v.2.#{@major_version_number}")
          end
        end
      end
    end
  end
end
