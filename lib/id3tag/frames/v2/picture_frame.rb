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
          0x06 => :media, # Media (e.g. label side of CD)
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
          if @major_version_number > 2
            result = parts[:mime_type]
            if StringUtil.blank?(result.strip)
              IMPLIED_MIME_TYPE
            else
              result
            end
          else
            image_format = parts[:mime_type].downcase
            if StringUtil.blank?(image_format.strip)
              IMPLIED_MIME_TYPE
            else
              IMPLIED_MIME_TYPE + image_format
            end
          end
        end

        def link?
          mime_type == LINK_SYMBOL
        end

        def type
          TYPES[parts[:picture_type_byte]]
        end

        def description
          encoding = get_encoding
          EncodingUtil.encode(parts[:description], encoding)
        end

        def content
          data
        end

        def data
          parts[:data]
        end

        private

        def parts
          @parts ||= read_parts!
        end

        def read_parts!
          usable_content_io.rewind
          parts = {}
          parts[:encoding_byte] = usable_content_io.getbyte
          if @major_version_number > 2
            parts[:mime_type] = ID3Tag::IOUtil.read_until_terminator(usable_content_io, 1)
          else
            parts[:mime_type] = usable_content_io.read(3)
          end
          parts[:picture_type_byte] = usable_content_io.getbyte
          parts[:description] = ID3Tag::IOUtil.read_until_terminator(usable_content_io, EncodingUtil.terminator_size(parts[:encoding_byte]))
          parts[:data] = usable_content_io.read
          parts
        end

        def usable_content_io
          @usable_content_io ||= StringIO.new(usable_content)
        end

        def get_encoding
          EncodingUtil.find_encoding(parts[:encoding_byte])
        end
      end
    end
  end
end
