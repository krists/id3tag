module  ID3Tag
  module Frames
    module  V2
      class PictureFrame < TextFrame
        def data
          get_parts[:data]
        end

        def type
          get_parts[:type]
        end

        # only 2.3 and 2.4
        def mime_type
          get_parts[:mime_type]
        end

        # only 2.2
        def format
          get_parts[:format]
        end

        def description
          get_parts[:description]
        end

        def content
          data
        end

        def inspectable_content
          "type=#{type} mime_type=#{mime_type} format=#{format} description=#{description} content=#{content.length} bytes #{content[0,10].inspect}"
        end

        private

        TYPES = {
          0x00 => :other, # Other
          0x01 => :file_icon_png32, # 32x32 pixels 'file icon' (PNG only)
          0x02 => :file_icon, # Other file icon
          0x03 => :cover_front, # Cover (front)
          0x04 => :cover_back, # Cover (back)
          0x05 => :leaflet_page, # Leaflet page
          0x06 => :media, # Media (e.g. lable side of CD)
          0x07 => :lead_artist, # Lead artist/lead performer/soloist
          0x08 => :qrtist, # Artist/performer
          0x09 => :conductor, # Conductor
          0x0a => :band, # Band/Orchestra
          0x0b => :composer, # Composer
          0x0c => :lyricist_writer, # Lyricist/text writer
          0x0d => :recording_location, # Recording Location
          0x0e => :ruring_recording, # During recording
          0x0f => :ruring_performance, # During performance
          0x10 => :movie_screen_capture, # Movie/video screen capture
          0x11 => :fish, # A bright coloured fish
          0x12 => :illustration, # Illustration
          0x13 => :band_logotype, # Band/artist logotype
          0x14 => :publisher_logotype # Publisher/Studio logotype
        }

        def get_parts
          @get_parts ||=
            case @major_version_number
            when 2 then parts22
            when 3, 4 then parts23
            end
        end

        def parts22
          raw = content_without_encoding_byte
          parts = {}
          parts[:format] = raw[0..2]
          parts[:type] = TYPES.fetch(raw[3].ord, :unknown)
          i = raw.index(source_terminator, 4)
          parts[:description] = raw[4..i-1].encode(destination_encoding, source_encoding, ID3Tag.configuration.string_encode_options)
          i += source_terminator.length
          parts[:data] = raw[i..-1]
          parts
        end

        def parts23
          raw = content_without_encoding_byte
          parts = {}
          i = raw.index("\x00") # skip mime type (always ISO 8859-1)
          parts[:mime_type] = raw[0..i-1]
          i += 1 # skip mime type terminator
          parts[:type] = TYPES.fetch(raw[i].ord, :unknown)
          i += 1 # skip picture type
          e = raw.index(source_terminator, i)
          parts[:description] = raw[i..e-1].encode(destination_encoding, source_encoding, ID3Tag.configuration.string_encode_options)
          i = e+source_terminator.length
          parts[:data] = raw[i..-1]
          parts
        end
      end
    end
  end
end
