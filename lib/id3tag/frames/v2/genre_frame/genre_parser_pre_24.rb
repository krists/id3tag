module ID3Tag
  module Frames
    module  V2
      class GenreFrame
        class GenreParserPre24 < GenreParser
          REFINEMENT_IN_PARENTHESES = /(\(\([^()]+\))/
          GENRE_NUMBERS_OR_NAMES = /\(([^)]+)\)/
          REFINEMENTS = /([)](?<blank>)[(][^(])|(\)(?<regular>[^()]+)[)]*)|(\((?<in_parentheses>\([^()]+\)))/

          def genres
            result = []
            just_genres.each_with_index do |genre, index|
              if ID3Tag::StringUtil.blank?(just_requirements[index])
                result << expand_abbreviation(genre)
              else
                result << just_requirements[index]
              end
            end
            result
          end

          private

          def just_genres
            genre_string.gsub(REFINEMENT_IN_PARENTHESES, '').scan(GENRE_NUMBERS_OR_NAMES).flatten
          end

          def just_requirements
            result = []
            genre_string.scan(REFINEMENTS) do |blank, regular, in_parentheses|
              result << (regular || in_parentheses || blank)
            end
            result
          end
        end
      end
    end
  end
end
