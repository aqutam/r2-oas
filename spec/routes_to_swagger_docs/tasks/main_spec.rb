require 'spec_helper'

RSpec.describe 'main_rake' do
  let(:task_name) { '' }
  let(:task) { Rake.application[task_name] }

  after do
    delete_swagger_docs
  end

  shared_examples_for 'Generated file verification test' do |result|
    it 'should generate docs' do
      expect(FileTest.exists? components_schemas_path).to eq result
      expect(FileTest.exists? components_request_bodies_path).to eq result
      expect(FileTest.exists? paths_path).to eq result
      expect(FileTest.exists? external_docs_path).to eq result
      expect(FileTest.exists? info_path).to eq result
      expect(FileTest.exists? openapi_path).to eq result
      expect(FileTest.exists? servers_path).to eq result
      expect(FileTest.exists? tags_path).to eq result
    end
  end

  describe 'routes:swagger:docs' do
    let(:task_name) { 'routes:swagger:docs' }

    before do
      task.invoke
    end

    it_behaves_like 'Generated file verification test', true
    it { expect(FileTest.exists? doc_save_file_path).to eq true }
  end

  describe 'routes:swagger:analyze' do
    let(:task_name) { 'routes:swagger:analyze' }
    let(:ext_name) { '' }

    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with('SWAGGER_FILE', '').and_return(swagger_file_path(ext_name))
      task.invoke
    end

    context 'when ext_name is :json' do
      let(:ext_name) { :json }

      it_behaves_like 'Generated file verification test', true
      it { expect(FileTest.exists? doc_save_file_path).to eq true }
    end

    context 'when ext_name is :yml' do
      let(:ext_name) { :yml }

      it_behaves_like 'Generated file verification test', true
      it { expect(FileTest.exists? doc_save_file_path).to eq true }
    end

    context 'when ext_name is :yaml' do
      let(:ext_name) { :yml }

      it_behaves_like 'Generated file verification test', true
      it { expect(FileTest.exists? doc_save_file_path).to eq true }
    end
  end

  describe 'routes:swagger:dist' do
    let(:task_name) { 'routes:swagger:dist' }

    before do
      generate_docs
    end

    it { expect(FileTest.exists? doc_save_file_path).to eq true }
  end

  describe 'routes:swagger:clean' do
    let(:task_name) { 'routes:swagger:clean' }

    before do
      create_dot_paths
      generate_docs
      create_dummy_components_schemas_file
      create_dummy_components_request_bodies_file
      create_components_securitySchemes_file()
      task.invoke
    end

    it do
      expect(FileTest.exists?("#{components_schemas_path}/dummy.yml")).to eq false
      expect(FileTest.exists?("#{components_request_bodies_path}/dummy.yml")).to eq false
      expect(FileTest.exists?("#{components_securitySchemes_path}/my_oauth.yml")).to eq true
    end
  end
end
