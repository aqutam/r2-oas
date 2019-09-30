# frozen_string_literal: true

require_relative 'app_configuration/server'
require_relative 'app_configuration/swagger'
require_relative 'app_configuration/tool'

module RoutesToSwaggerDocs
  module AppConfiguration
    DEFAULT_ROOT_DIR_PATH = './swagger_docs'
    DEFAULT_SCHEMA_SAVE_DIR_NAME = 'src'
    DEFAULT_DOC_SAVE_FILE_NAME = 'swagger_doc.yml'
    DEFAULT_FORCE_UPDATE_SCHEMA = false
    DEFAULT_USE_TAG_NAMESPACE = true
    DEFAULT_USE_SCHEMA_NAMESPACE = true
    DEFAULT_SERVER = Server.new
    DEFAULT_INTERVAL_TO_SAVE_EDITED_TMP_SCHEMA = 15
    DEFAULT_SWAGGER = Swagger.new
    # rubocop:disable Style/MutableConstant
    DEFAULT_HTTP_STATUSES_WHEN_HTTP_METHOD = {
      get: {
        default: %w[200 422],
        path_parameter: %w[200 404 422]
      },
      post: {
        default: %w[204 422],
        path_parameter: %w[204 404 422]
      },
      patch: {
        default: %w[204 422],
        path_parameter: %w[204 404 422]
      },
      put: {
        default: %w[204 422],
        path_parameter: %w[204 404 422]
      },
      delete: {
        default: %w[200 422],
        path_parameter: %w[200 404 422]
      }
    }
    DEFAULT_HTTP_METHODS_WHEN_GENERATE_REQUEST_BODY = %w[post patch put]
    # rubocop:enable Style/MutableConstant
    DEFAULT_TOOL = Tool.new
    # :dot or :underbar
    DEFAULT_NAMESPACE_TYPE = :underbar

    PUBLIC_VALID_OPTIONS_KEYS = %i[
      root_dir_path
      schema_save_dir_name
      doc_save_file_name
      force_update_schema
      use_tag_namespace
      use_schema_namespace
      server
      interval_to_save_edited_tmp_schema
      swagger
      http_statuses_when_http_method
      http_methods_when_generate_request_body
      tool
      namespace_type
    ].freeze

    UNPUBLIC_VALID_OPTIONS_KEYS = %i[
      paths_config
      logger
    ].freeze

    VALID_OPTIONS_KEYS = PUBLIC_VALID_OPTIONS_KEYS + UNPUBLIC_VALID_OPTIONS_KEYS

    attr_accessor *PUBLIC_VALID_OPTIONS_KEYS

    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    private

    module_function def set_default(target)
      target.root_dir_path = DEFAULT_ROOT_DIR_PATH
      target.schema_save_dir_name                    = DEFAULT_SCHEMA_SAVE_DIR_NAME
      target.doc_save_file_name                      = DEFAULT_DOC_SAVE_FILE_NAME
      target.force_update_schema                     = DEFAULT_FORCE_UPDATE_SCHEMA
      target.use_tag_namespace                       = DEFAULT_USE_TAG_NAMESPACE
      target.use_schema_namespace                    = DEFAULT_USE_SCHEMA_NAMESPACE
      target.server                                  = DEFAULT_SERVER
      target.interval_to_save_edited_tmp_schema      = DEFAULT_INTERVAL_TO_SAVE_EDITED_TMP_SCHEMA
      target.swagger                                 = DEFAULT_SWAGGER
      target.http_statuses_when_http_method          = DEFAULT_HTTP_STATUSES_WHEN_HTTP_METHOD
      target.tool                                    = DEFAULT_TOOL
      target.http_methods_when_generate_request_body = DEFAULT_HTTP_METHODS_WHEN_GENERATE_REQUEST_BODY
      target.namespace_type                          = DEFAULT_NAMESPACE_TYPE
    end
  end
end
