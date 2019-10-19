## Basic Usage

```ruby

require 'r2-oas'

R2OAS.configure do |config|
   # default setting        
   config.root_dir_path        = "./swagger_docs"
   config.schema_save_dir_name = "src"
   config.doc_save_file_name   = "swagger_doc.yml"
end
```

```bash
$ bundle exec rake routes:oas:paths_ls
/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/user.yml
/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/account_user_role.yml
/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/user.yml
/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/account.yml
/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/task.yml
/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/post.yml
/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v2/custom_post.yml
/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v2/post.yml
/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/task.yml
/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/engine.yml
/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/main.yml
```
