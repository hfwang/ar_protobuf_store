require 'ar_protobuf_store'
require 'rails'

module ArProtobufStore
  class Railtie < ::Rails::Railtie
    initializer "ar_protobuf_store.active_record" do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send :include, ArProtobufStore
      end
    end
  end
end
