module  ID3Tag
  module Frames
    module  V2
      class FrameFlags
        FLAG_INDEXES_BY_VERSION = {
          3 => {
            :status_flags => [
              :preserve_on_tag_alteration,
              :preserve_on_file_alteration,
              :read_only,
              nil,
              nil,
              nil,
              nil,
              nil
            ],
            :format_flags => [
              :compressed,
              :encrypted,
              :grouped,
              nil,
              nil,
              nil,
              nil,
              nil
            ]
          },
          4 => {
            :status_flags => [
              nil,
              :preserve_on_tag_alteration,
              :preserve_on_file_alteration,
              :read_only,
              nil,
              nil,
              nil,
              nil
            ],
            :format_flags => [
              nil,
              :grouped,
              nil,
              nil,
              :compressed,
              :encrypted,
              :unsynchronised,
              :data_length_indicator
            ]
          }
        }

        def initialize(flag_bytes, major_version_number)
          @flag_bytes = flag_bytes
          @major_version_number = major_version_number
        end

        def preserve_on_tag_alteration?
          status_flag(:preserve_on_tag_alteration) != 1
        end

        def preserve_on_file_alteration?
          status_flag(:preserve_on_file_alteration) != 1
        end

        def read_only?
          status_flag(:read_only) == 1
        end

        def compressed?
          format_flag(:compressed) == 1
        end

        def encrypted?
          format_flag(:encrypted) == 1
        end

        def grouped?
          format_flag(:grouped) == 1
        end

        def data_length_indicator?
          format_flag(:data_length_indicator) == 1
        end

        private

        def status_flag(name)
          index = index_of_status_flag(name)
          if index
            flags = flags_byte_pair.first
            flags && flags[7 - index]
          end
        end

        def format_flag(name)
          index = index_of_format_flag(name)
          if index
            flags = flags_byte_pair.last
            flags && flags[7 - index]
          end
        end

        def flags_byte_pair
          @flag_bytes.to_s.unpack("C2")
        end

        def index_of_status_flag(name)
          current_version_map[:status_flags].find_index(name)
        end

        def index_of_format_flag(name)
          current_version_map[:format_flags].find_index(name)
        end

        def current_version_map
          FLAG_INDEXES_BY_VERSION.fetch(@major_version_number) do
            { :status_flags => [], :format_flags => [] }
          end
        end
      end
    end
  end
end
