module  ID3Tag
  module Frames
    module  V2
      class PictureFrame < BasicFrame
        LINK_SYMBOL = '-->'
        IMPLIED_MIME_TYPE = 'image/'
        TYPES = {
          0x00 => :other, # Other
          0x01 => :file_icon_png32, # 32x32 pixels 'file icon' (PNG only)
          0x02 => :file_icon, # Other file icon
          0x03 => :cover_front, # Cover (front)
          0x04 => :cover_back, # Cover (back)
          0x05 => :leaflet_page, # Leaflet page
          0x06 => :media, # Media (e.g. lable side of CD)
          0x07 => :lead_artist, # Lead artist/lead performer/soloist
          0x08 => :artist, # Artist/performer
          0x09 => :conductor, # Conductor
          0x0a => :band, # Band/Orchestra
          0x0b => :composer, # Composer
          0x0c => :lyricist, # Lyricist/text writer
          0x0d => :recording_location, # Recording Location
          0x0e => :during_recording, # During recording
          0x0f => :during_performance, # During performance
          0x10 => :movie_screen_capture, # Movie/video screen capture
          0x11 => :fish, # A bright coloured fish
          0x12 => :illustration, # Illustration
          0x13 => :band_logotype, # Band/artist logotype
          0x14 => :publisher_logotype # Publisher/Studio logotype
        }

        def mime_type
          usable_content_io.seek(1)
          if @major_version_number > 2
            term_result = ID3Tag::IOUtil.find_terminator(usable_content_io, 1)
            result = usable_content_io.read(term_result.byte_count_before_terminator)
            if StringUtil.blank?(result)
              IMPLIED_MIME_TYPE
            else
              result
            end
          else
            IMPLIED_MIME_TYPE + usable_content_io.read(3)
          end
        end

        def link?
          mime_type == LINK_SYMBOL
        end

        def type
          usable_content_io.seek(position_of_type_byte)
          TYPES[usable_content_io.getbyte]
        end

        def description
          encoding = get_encoding
          terminator_size = get_terminator_size
          usable_content_io.seek(position_of_start_of_description)
          term_result = ID3Tag::IOUtil.find_terminator(usable_content_io, terminator_size)
          text = usable_content_io.read(term_result.byte_count_before_terminator)
          EncodingUtil.encode(text, encoding)
        end

        def content
          data
        end

        def data
          usable_content_io.seek(position_of_binary_data)
          usable_content_io.read
        end

        private

        def usable_content_io
          @usable_content_io ||= StringIO.new(usable_content)
        end

        def position_of_binary_data
          terminator_size = get_terminator_size
          usable_content_io.seek(position_of_start_of_description)
          term_result = ID3Tag::IOUtil.find_terminator(usable_content_io, terminator_size)
          term_result.end_pos
        end

        def position_of_type_byte
          if @major_version_number > 2
            usable_content_io.seek(1)
            term_result = ID3Tag::IOUtil.find_terminator(usable_content_io, 1)
            term_result.byte_count_of_content_and_terminator + 1
          else
            4
          end
        end

        def position_of_start_of_description
          position_of_type_byte + 1
        end

        def get_encoding
          EncodingUtil.find_encoding(encoding_byte)
        end

        def get_terminator_size
          EncodingUtil.terminator_size(encoding_byte)
        end

        def encoding_byte
          @encoding_byte ||= get_encoding_byte
        end

        def get_encoding_byte
          usable_content_io.rewind
          usable_content_io.getbyte
        end
      end
    end
  end
end
