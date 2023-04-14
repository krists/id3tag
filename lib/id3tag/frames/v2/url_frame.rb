module ID3Tag
  module Frames
    module V2
      class UrlFrame < BasicFrame
        alias_method :url, :content
        alias_method :inspectable_content, :content
      end
    end
  end
end
