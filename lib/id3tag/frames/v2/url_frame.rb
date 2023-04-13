module ID3Tag
  module Frames
    module V2
      class UrlFrame < BasicFrame
        def url
          raw_content
        end

        alias_method :content, :url
        alias_method :inspectable_content, :content
      end
    end
  end
end
