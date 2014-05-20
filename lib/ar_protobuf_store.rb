require 'ar_protobuf_store/version'

require 'ar_protobuf_store/railtie.rb' if defined?(Rails)

module ArProtobufStore
  class NilFriendlyPb
    def initialize(pb_class, opts = nil)
      @klass = pb_class
      @opts = opts
      @opts ||=  { :default => Proc.new { pb_class.new() } }
    end

    def load(str)
      if str.nil?
        return default_value
      else
        return @klass.new.tap { |o| o.parse(str) }
      end
    rescue Exception
      Rails.logger.error("Failed to deserialize: #{$!}")
      return default_value
    end

    def dump(str)
      str.serialize_to_string
    end

    private
    def default_value
      if @opts[:default].respond_to? :call
        @opts[:default].call
      elsif @opts[:default].duplicable?
        @opts[:default].dup
      else
        @opts[:default]
      end
    end
  end

  extend ActiveSupport::Concern

  module ClassMethods
    def protobuf_store(store_attribute, pb_class, options={})
      serialize(store_attribute, NilFriendlyPb.new(pb_class))
      if options.has_key? :accessors
        store_accessor(store_attribute, options[:accessors])
      else
        store_accessor(store_attribute, pb_class.fields.values.map(&:name))
      end
    end

    def protobuf_store_accessor(store_attribute, *keys)
      Array(keys).flatten.each do |key|
        class_eval <<-"END_EVAL", __FILE__, __LINE__
          def #{key}=(value)
            self.#{store_attribute}_will_change!
            self.#{store_attribute}.#{key} = value
          end
          def #{key}
            self.#{store_attribute}.#{key}
          end
        END_EVAL
      end
    end
  end
end
