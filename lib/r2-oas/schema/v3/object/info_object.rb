# frozen_string_literal: true

require 'r2-oas/plugins/schema/v3/object/hookable_base_object'

module R2OAS
  module Schema
    module V3
      class InfoObject < R2OAS::Plugins::Schema::V3::HookableBaseObject
        def create_doc
          result = {
            'title' => 'OAS API Document Title',
            'description' => "This is a sample server Petstore server.  You can find out more about
            Swagger at [http://swagger.io](http://swagger.io) or on [irc.freenode.net,
            #swagger](http://swagger.io/irc/).  For this sample, you can use the api key
            `special-key` to test the authorization filters.",
            'termsOfService' => 'http://swagger.io/terms/',
            # Contact Object
            'contact' => {
              'name' => '',
              'url' => ''
            },
            # License Object
            'license' => {
              'name' => '',
              'url' => ''
            },
            'version' => '1.0.0'
          }
          doc.merge!(result)
        end
      end
    end
  end
end