# frozen_string_literal: true

require 'r2-oas/schema/v3/base'

# Scope Rails
module R2OAS
  module Schema
    module V3
      class BaseAnalyzer < Base
        include Sortable

        def initialize(before_schema_data, after_schema_data, options = {})
          super(options)
          @type = options[:type].presence
          @before_schema_data = before_schema_data
          @after_schema_data  = after_schema_data.presence || create_after_schema_data
        end

        def analyze_docs
          raise NoImplementError, 'Please implement in inherited class.'
        end

        def generate_from_existing_schema
          raise NoImplementError, 'Please implement in inherited class.'
        end

        private

        attr_accessor :existing_schema_file_path
        attr_accessor :type

        def create_after_schema_data
          case @type
          when :edited
            {}
          when :existing
            if existing_schema_file_path.present?
              create_after_schema_data_when_specify_path
            else
              create_after_schema_data_when_not_specify_path
            end
          end
        end

        def create_after_schema_data_when_not_specify_path
          if File.exist?(doc_save_file_path)
            YAML.load_file(doc_save_file_path)
          else
            raise NoFileExistsError, "Do not exists file: #{doc_save_file_path}"
          end
        end

        def create_after_schema_data_when_specify_path
          extname = File.extname(existing_schema_file_path)
          case extname
          when /json/
            File.open(existing_schema_file_path) do |file|
              JSON.parse(file.read)
            end
          when /yaml/
            YAML.load_file(existing_schema_file_path)
          when /yml/
            YAML.load_file(existing_schema_file_path)
          else
            raise NoImplementError, "Do not support extension: #{extname}"
          end
        end
      end
    end
  end
end
