require "rspec"
require "ar_protobuf_store"

require "active_record"

if RUBY_VERSION > "1.8.7"
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Schema.verbose = false

def setup_db(&block)
  # ActiveRecord caches columns options like defaults etc. Clear them!
  ActiveRecord::Base.connection.schema_cache.clear!
  ActiveRecord::Schema.define(:version => 1, &block)
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end
