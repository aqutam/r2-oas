# frozen_string_literal: true

require 'fileutils'

require_relative 'app_configuration'
require_relative 'configuration/paths_config'
require_relative 'logger/stdout_logger'
require_relative 'support/deprecation'
require_relative 'helpers/file_helper'

module R2OAS
  module Configuration
    extend AppConfiguration
    include Helpers::FileHelper

    PUBLIC_VALID_OPTIONS_KEYS = AppConfiguration::VALID_OPTIONS_KEYS

    UNPUBLIC_VALID_OPTIONS_KEYS = %i[
      paths_config
      logger
    ].freeze

    VALID_OPTIONS_KEYS = PUBLIC_VALID_OPTIONS_KEYS + UNPUBLIC_VALID_OPTIONS_KEYS

    attr_accessor *PUBLIC_VALID_OPTIONS_KEYS

    def self.extended(base)
      base.send :set_default_for_configuration, base
    end

    def configure
      yield self if block_given?
      load_local_plugins
    end

    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    def logger
      @_stdout_logger ||= StdoutLogger.new
    end

    def paths_config
      @_paths_config ||= PathsConfig.new(root_dir_path, schema_save_dir_name)
    end

    def app_configuration_options
      AppConfiguration::VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    def load_tasks
      load_local_tasks
    end

    def init
      old_stdout = $stdout
      $stdout = StringIO.new

      plugins_path = File.expand_path("#{root_dir_path}/#{local_plugins_dir_name}")
      plugins_helpers_path = "#{plugins_path}/helpers"
      tasks_path = File.expand_path("#{root_dir_path}/#{local_tasks_dir_name}")
      tasks_helpers_path = "#{tasks_path}/helpers"

      gitkeep_plugins_path = "#{plugins_path}/.gitkeep"
      gitkeep_plugins_helpers_path = "#{plugins_helpers_path}/.gitkeep"
      gitkeep_tasks_path = "#{tasks_path}/.gitkeep"
      gitkeep_tasks_helpers_path = "#{tasks_helpers_path}/.gitkeep"

      paths_config.create_dot_paths(false)
      mkdir_p_dir_or_skip(plugins_helpers_path)
      mkdir_p_dir_or_skip(tasks_helpers_path)
      write_file_or_skip(gitkeep_plugins_path, '')
      write_file_or_skip(gitkeep_plugins_helpers_path, '')
      write_file_or_skip(gitkeep_tasks_path, '')
      write_file_or_skip(gitkeep_tasks_helpers_path, '')

      if $stdout.string.present?
        STDOUT.puts $stdout.string
      else
        STDOUT.puts "Already Initialized existing oas_docs in #{root_dir_path}"
      end

      $stdout = old_stdout
    end

    def output_dir_path
      output_path.to_s.split('/').slice(0..-2).join('/')
    end

    private

    def load_local_tasks
      tasks_path = File.expand_path("#{root_dir_path}/#{local_tasks_dir_name}")
      Dir.glob("#{tasks_path}/**/*.rake").sort.each do |file|
        load file if File.exist?(file)
      end
    end

    def load_local_plugins
      plugins_path = File.expand_path("#{root_dir_path}/#{local_plugins_dir_name}")
      Dir.glob("#{plugins_path}/**/*.rb").sort.each do |file|
        require file if File.exist?(file)
      end
    end

    def set_default_for_configuration(target)
      AppConfiguration.set_default(target)
    end
  end
end
