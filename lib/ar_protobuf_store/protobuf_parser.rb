module ArProtobufStore
  class ProtobufParser
    def initialize(pb_class, opts = nil)
      @klass = pb_class
      @opts = opts || {}
      @opts = {
        :default => Proc.new { pb_class.new() }
      }.merge(opts || {})
    end

    def load(str)
      if str.nil?
        return default_value
      else
        return @klass.new.tap { |o| o.parse_from_string(str) }
      end
    rescue Exception
      if defined?(Rails)
        Rails.logger.error("Failed to deserialize: #{$!}")
      else
        puts "Failed to deserialize: #{$!}"
      end

      return default_value
    end

    def dump(str)
      str.serialize_to_string
    rescue Exception
      if defined?(Rails)
        Rails.logger.error("Failed to serialize: #{$!}")
      else
        puts "Failed to serialize: #{$!}"
      end

      return nil
    end

    def extract_fields(accessors = nil)
      fields = @klass.fields
      fields = fields.values if fields.respond_to?(:values)

      if !accessors.nil?
        accessors = accessors.dup.map { |a| a.to_s }
        fields = fields.select { |field|
          accessors.include?(field.name.to_s)
        }
      end

      typed_fields = fields.map do |field|
        t = case field
            when Protobuf::Field::StringField
              :string
            when Protobuf::Field::BoolField
              :bool
            when Protobuf::Field::IntegerField, Protobuf::Field::Uint32Field, Protobuf::Field::Uint64Field
              :int
            when Protobuf::Field::FloatField
              :float
            else
              nil
            end
        { :name => field.name.to_s, :type => t }
      end

      return typed_fields
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
end
