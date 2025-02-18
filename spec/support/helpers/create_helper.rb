# frozen_string_literal: true

require_relative 'path_helper'
require_relative 'fixture_helper'

module CreateHelper
  include PathHelper
  include FixtureHelper

  def init
    create_output_dir
    create_dot_paths
  end

  def create_dir(path = '')
    FileUtils.mkdir_p Rails.root.join(src_path, path)
  end

  def delete_oas_docs
    FileUtils.rm_rf Rails.root.join(root_dir_path)
  end

  def delete_deploy_docs
    FileUtils.rm_rf Rails.root.join(deploy_dir_path)
  end

  def delete_cache_docs
    FileUtils.rm_rf Rails.root.join(relative_cache_docs_path)
  end

  def create_components_securitySchemes_file
    FileUtils.mkdir_p(components_securitySchemes_path) unless File.exist?(components_securitySchemes_path)
    File.write("#{components_securitySchemes_path}/my_oauth.yml", yaml_fixture('src/components/securitySchemes/my_oauth.yml'))
  end

  def create_paths_file(file_name = 'dummy.yml', yaml = "---\n")
    dirname = File.dirname("#{paths_path}/#{file_name}")
    FileUtils.mkdir_p(dirname) unless File.exist?(dirname)
    File.write("#{paths_path}/#{file_name}", yaml)
  end

  def create_components_schemas_file(file_name = 'dummy.yml', yaml = "---\n")
    dirname = File.dirname("#{components_schemas_path}/#{file_name}")
    FileUtils.mkdir_p(dirname) unless File.exist?(dirname)
    File.write("#{components_schemas_path}/#{file_name}", yaml)
  end

  def create_components_request_bodies_file(file_name = 'dummy.yml', yaml = "---\n")
    dirname = File.dirname("#{components_request_bodies_path}/#{file_name}")
    FileUtils.mkdir_p(dirname) unless File.exist?(dirname)
    File.write("#{components_request_bodies_path}/#{file_name}", yaml)
  end

  def create_save_doc
    schema_data = YAML.load_file(swagger_file_path(:yml))
    File.write(doc_save_file_path, schema_data.to_yaml)
  end

  def prepare_standard_files
    # Task
    create_components_schemas_file('api/v1/task.yml', yaml_fixture('src/components/schemas/api/v1/task.yml'))
    create_components_schemas_file('api/v1/task/rb.yml', yaml_fixture('src/components/schemas/api/v1/task/rb.yml'))
    create_components_request_bodies_file('api/v1/task/rb.yml', yaml_fixture('src/components/requestBodies/api/v1/task/rb.yml'))
    create_paths_file('api/v1/task.yml', yaml_fixture('src/paths/api/v1/task.yml'))
    # User
    create_components_schemas_file('/api/v1/user.yml', yaml_fixture('src/components/schemas/api/v1/user.yml'))
    create_paths_file('api/v1/user.yml', yaml_fixture('src/paths/api/v1/user.yml'))
  end

  def copy_tasks
    FileUtils.mkdir Rails.root.join(root_dir_path) unless File.exist?(Rails.root.join(root_dir_path))

    local_tasks_path = Rails.root.join('tasks')
    FileUtils.cp_r(local_tasks_path, tasks_path)
  end

  private

  def create_dot_paths
    R2OAS.paths_config.create_dot_paths
  end

  def create_output_dir
    FileUtils.mkdir_p(output_dir_path) unless File.exist?(output_dir_path)
  end
end
