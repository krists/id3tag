module  ID3Tag
  module Frames
    module  V2
      class FrameFlags
        FLAG_MAP_IN_APPEARANCE_ORDER_BY_VERSION = {
          3 => {
            :status_flags => [ :preserve_on_tag_alteration, :preserve_on_file_alteration, :read_only, nil, nil, nil, nil, nil ],
            :format_flags => [ :compressed, :encrypted, :grouped, nil, nil, nil, nil, nil ]
          },
          4 => {
            :status_flags => [ nil, :preserve_on_tag_alteration, :preserve_on_file_alteration, :read_only, nil, nil, nil, nil ],
            :format_flags => [ nil, :grouped, nil, nil, :compressed, :encrypted, :unsynchronised, :data_length_indicator ]
          }
        }

        ADDITIONAL_INFO_BYTES_IN_APPEARANCE_ORDER_BY_VERSION = {
          3 => [
            [:compressed?, 4], [:encrypted?, 1], [:grouped?, 1]
          ],
          4 => [
            [:grouped?, 1], [:encrypted?, 1], [:data_length_indicator?, 4]
          ]
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

        def additional_info_byte_count
          additional_info_flags_in_effect.inject(0) do |total, query|
            total += query.last
            total
          end
        end

        def position_and_count_of_data_length_bytes
          if data_length_indicator? || compressed?
            find_position_and_length_for_additional_info(:data_length_indicator?, :compressed?)
          end
        end

        def position_and_count_of_group_id_bytes
          if grouped?
            find_position_and_length_for_additional_info(:grouped?)
          end
        end

        def position_and_count_of_encryption_id_bytes
          if encrypted?
            find_position_and_length_for_additional_info(:encrypted?)
          end
        end

        def find_position_and_length_for_additional_info(*methods_of_interest)
          start_position = 0
          target_info_byte_count = nil
          additional_info_flags_in_effect.map do |query_method, byte_count|
            start_position += (byte_count) unless methods_of_interest.include?(query_method)
            if methods_of_interest.include?(query_method)
              target_info_byte_count = byte_count
              break
            end
          end
          [start_position, target_info_byte_count]
        end

        def additional_info_flags_in_effect
          current_additional_info_map.reject { |q| !self.send(q.first) }
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
          current_flag_map[scope].find_index(name)
        end

        def current_flag_map
          FLAG_MAP_IN_APPEARANCE_ORDER_BY_VERSION.fetch(@major_version_number) do
            { :status_flags => [], :format_flags => [] }
          end
        end

        def current_additional_info_map
          ADDITIONAL_INFO_BYTES_IN_APPEARANCE_ORDER_BY_VERSION.fetch(@major_version_number) { [] }
        end
      end
    end
  end
end
