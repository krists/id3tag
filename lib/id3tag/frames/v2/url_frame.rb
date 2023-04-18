module ID3Tag
  module Frames
    module V2
      class UrlFrame < BasicFrame
        def url
          @url ||= StringUtil.cut_at_null_byte(usable_content)
        end

        alias_method :content, :url
        alias_method :inspectable_content, :content
      end
    end
  end
end
