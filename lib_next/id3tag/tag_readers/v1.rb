# frozen_string_literal: true

module ID3Tag
  module TagReaders
    class V1
      TAG_SIZE = 128
      TAG_IDENTIFIER = "TAG"

      def initialize(file)
        @file = file
      end

      def present?
        if @file.size >= TAG_SIZE
          @file.seek(-TAG_SIZE, IO::SEEK_END)
          @file.read(3) == TAG_IDENTIFIER
        else
          false
        end
      end

      def body
        if present?
          @file.seek(-body_size, IO::SEEK_END)
          @file.read
        end
      end
      
      private

      def body_size
        if present?
          125 # TAG_SIZE - TAG_IDENTIFIER char count
        else
          0
        end
      end

    end
  end
end