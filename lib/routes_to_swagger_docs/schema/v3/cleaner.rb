# frozen_string_literal: true

require_relative 'cleaner/base_cleaner'
require_relative 'cleaner/components_cleaner'

module RoutesToSwaggerDocs
  module Schema
    class Cleaner < BaseCleaner
      def clean_docs
        logger.info '[Clean Swagger file] start'
        components_cleaner = ComponentsCleaner.new(@options)
        components_cleaner.clean_docs
        logger.info '[Clean Swagger file] end'
      end
    end
  end
end
