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
          flag(:status_flags, :preserve_on_tag_alteration) != 1
        end

        def preserve_on_file_alteration?
          flag(:status_flags, :preserve_on_file_alteration) != 1
        end

        def read_only?
          flag(:status_flags, :read_only) == 1
        end

        def compressed?
          flag(:format_flags, :compressed) == 1
        end

        def encrypted?
          flag(:format_flags, :encrypted) == 1
        end

        def grouped?
          flag(:format_flags, :grouped) == 1
        end

        def unsynchronised?
          flag(:format_flags, :unsynchronised) == 1
        end

        def data_length_indicator?
          flag(:format_flags, :data_length_indicator) == 1
        end

        private

        def flag(scope, name)
          index = index_of_flag(scope, name)
          if index
            flags = flags_for_scope(scope)
            flags && flags[7 - index]
          end
        end

        def flags_for_scope(scope)
          pair = @flag_bytes.to_s.unpack("C2")
          case scope
          when :status_flags
            pair.first
          when :format_flags
            pair.last
          end
        end

        def index_of_flag(scope, name)
          current_version_map[scope].find_index(name)
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
