module ID3Tag
  module Frames
    module  V2
      class GenreFrame
        class GenreParser
          NUMERIC = /\A\d+\z/
          attr_reader :genre_string

          def initialize(genre_string)
            @genre_string = genre_string
          end

          def expand_abbreviation(abbreviation)
            case abbreviation
            when 'CR'
              'Cover'
            when 'RX'
              'Remix'
            else
              if abbreviation =~ NUMERIC
                Util::GenreNames.find_by_id(abbreviation.to_i)
              else
                abbreviation
              end
            end
          end

          def genres
            raise "#genres is not implemented for class #{self.class}"
          end
        end
      end
    end
  end
end

