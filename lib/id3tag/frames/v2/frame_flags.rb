module  ID3Tag
  module Frames
    module  V2
      class FrameFlags
        EXCLUDE_END_TRUE = true
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
          current_additional_info_map.inject(0) do |total, query|
            total += query.last if self.send(query.first)
            total
          end
        end

        def range_of_data_length_bytes
          if data_length_indicator?
            cursor = 0
            length = 0
            current_additional_info_map.reject { |q| !self.send(q.first) }.map do |q|
              cursor += q.last if q.first != :data_length_indicator?
              if q.first == :data_length_indicator?
                length = q.last
                break
              end
            end
            Range.new(cursor,cursor + length, EXCLUDE_END_TRUE)
          end
        end

        def range_of_group_id
          if grouped?
            cursor = 0
            length = 0
            current_additional_info_map.reject { |q| !self.send(q.first) }.map do |q|
              cursor += q.last if q.first != :grouped?
              if q.first == :grouped?
                length = q.last
                break
              end
            end
            Range.new(cursor, cursor + length, EXCLUDE_END_TRUE)
          end
        end

        def range_of_encryption_id
          if encrypted?
            cursor = 0
            length = 0
            current_additional_info_map.reject { |q| !self.send(q.first) }.map do |q|
              cursor += q.last if q.first != :encrypted?
              if q.first == :encrypted?
                length = q.last
                break
              end
            end
            Range.new(cursor, cursor + length, EXCLUDE_END_TRUE)
          end
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
