module ID3Tag
  module Frames
    module V2
      class UserUrlFrame < TextFrame
        def description
          @description ||= parts.first
        end

        def url
          @url ||= parts.last
        end

        alias_method :content, :url
        alias_method :inspectable_content, :content

        private

        def parts
          @parts ||= encoded_content.split(StringUtil::NULL_BYTE, 2)
        end
      end
    end
  end
end
