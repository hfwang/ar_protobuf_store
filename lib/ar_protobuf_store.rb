require 'ar_protobuf_store/version'

require 'ar_protobuf_store/railtie.rb' if defined?(Rails)

module ArProtobufStore
  autoload(:CodekitchenProtobufParser,
           "ar_protobuf_store/codekitchen_protobuf_parser")
  autoload(:ProtobufParser,
           "ar_protobuf_store/protobuf_parser")

  def self.included(base)
    base.extend(ClassMethods)
  end

  def self.find_parser!(pb_class)
    if defined?(ProtocolBuffers) && ::ProtocolBuffers::Message > pb_class
      return ArProtobufStore::CodekitchenProtobufParser.new(pb_class)
    elsif defined?(Protobuf) && ::Protobuf::Message > pb_class
      return ArProtobufStore::ProtobufParser.new(pb_class)
    else
      raise "Could not identify protocol buffer library for #{pb_class}"
    end
  end

  module ClassMethods
    def protobuf_store(store_attribute, pb_class, options={})
      parser = ArProtobufStore.find_parser!(pb_class)
      serialize(store_attribute, parser)
      protobuf_store_accessor(store_attribute, parser.extract_fields(options[:accessors]))
    end

    def protobuf_store_accessor(store_attribute, *keys)
      Array(keys).flatten.each do |key|
        name = key[:name]
        coercer = case key[:type]
                  when :int
                    "%s.to_i"
                  when :float
                    "%s.to_f"
                  when :string
                    "%s.to_s"
                  when :bool
                    "!!%s"
                  else
                    "%s"
                  end
        class_eval <<-"END_EVAL", __FILE__, __LINE__
          def #{name}=(value)
            self.#{store_attribute}_will_change!
            self.#{store_attribute}.#{name} = #{coercer % 'value'}
          end
          def #{name}
            self.#{store_attribute}.#{name}
          end
        END_EVAL
      end
    end
  end
end
