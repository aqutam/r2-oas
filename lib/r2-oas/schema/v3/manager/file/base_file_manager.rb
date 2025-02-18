# frozen_string_literal: true

require_relative '../pathname_manager'
require 'r2-oas/schema/v3/base'

module R2OAS
  module Schema
    module V3
      class BaseFileManager < Base
        attr_accessor :original_path

        # e.x.) openapi_path = "#/components/schemas/Account"
        def initialize(path, path_type = :full)
          super()
          @ext_name = :yml
          @path_type = path_type
          @original_path = path
          @relative_save_file_path = PathnameManager.new(path, path_type).relative_save_file_path
        end

        def delete
          File.delete(save_file_path) if File.exist?(save_file_path)
        end

        def save(data)
          abs_dir = File.dirname(save_file_path)
          FileUtils.mkdir_p(abs_dir) unless File.exist?(abs_dir)
          File.write(save_file_path, data)
        end

        def save_after_deep_merge(data)
          result = load_data.deep_merge(data)
          save(result.to_yaml)
        end

        def save_file_path(type: :full)
          file_path = File.expand_path(@relative_save_file_path)

          case type
          when :relative
            file_path.sub(%r{^#{Dir.getwd}/?}, '')
          else
            file_path
          end
        end

        def load_data
          case @ext_name
          when :yml
            if File.exist?(save_file_path)
              YAML.load_file(save_file_path)
            else
              {}
            end
          else
            raise NoSupportError, "Do not support @ext_name: #{@ext_name}"
          end
        end

        def descendants_paths
          []
        end
      end
    end
  end
end
