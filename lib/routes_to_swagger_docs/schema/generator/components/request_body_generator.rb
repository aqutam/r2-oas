# frozen_string_literal: true

require 'forwardable'
require 'fileutils'
require_relative '../base_generator'
require_relative '../../manager/file/components/request_body_file_manager'

module RoutesToSwaggerDocs
  module Schema
    module Components
      class RequestBodyGenerator < BaseGenerator
        def initialize(schema_data = {}, options = {})
          super(schema_data, options)
          sorted_schema_data = deep_sort(schema_data, 'requestBodies')
          @components_request_bodies = sorted_schema_data['requestBodies']
          @glob_schema_paths = create_glob_components_request_bodies_paths
        end

        def generate_components_request_bodies
          if components_request_bodies_file_do_not_exists?
            logger.info ' <From routes data>'
            generate_components_request_bodies_from_routes_data
          else
            logger.info ' <From schema files>'
            generate_components_request_bodies_from_schema_fiels
          end
        end

        private

        attr_accessor :components_file_paths
        alias components_request_bodies_files_paths schema_files_paths
        alias components_request_bodies_file_do_not_exists? schema_file_do_not_exists?

        def generate_components_request_bodies_from_schema_fiels
          components_request_bodies_from_schema_files = components_request_bodies_files_paths.each_with_object({}) do |path, data|
            yaml = YAML.load_file(path)
            data.deep_merge!(yaml)
            full_path = File.expand_path(path, './')
            logger.info "  Fetch Components schema file: \t#{full_path}"
          end
          @components_request_bodies.deep_merge!(components_request_bodies_from_schema_files['components']['requestBodies'])
          process_when_generate_components_request_bodies do |save_file_path|
            logger.info "  Merge schema file: \t#{save_file_path}"
          end
        end

        def generate_components_request_bodies_from_routes_data
          process_when_generate_components_request_bodies do |save_file_path|
            logger.info "  Write schema file: \t#{save_file_path}"
          end
        end

        def process_when_generate_components_request_bodies(components_request_bodies_override: false)
          logger.info ' <Update Components schema files (components/schemas)>'
          @components_request_bodies.each do |schema_name, data|
            result = {
              'components' => {
                'requestBodies' => { schema_name.to_s => data }
              }
            }

            relative_path = "components/requestBodies/#{schema_name}"
            file_manager = Components::RequestBodyFileManager.new(relative_path, :relative)

            file_manager.save(result.to_yaml) unless file_manager.skip_save?

            yield file_manager.save_file_path if block_given?
          end
        end

        def create_glob_components_request_bodies_paths
          if components_file_paths.present?
            components_file_paths
          else
            ["#{schema_save_dir_path}/components/requestBodies/**/**.yml"]
          end
        end
      end
    end
  end
end
