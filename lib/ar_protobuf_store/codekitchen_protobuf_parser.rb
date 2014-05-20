module ArProtobufStore
  class CodekitchenProtobufParser
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
      if defined?(Rails)
        Rails.logger.error("Failed to deserialize: #{$!}")
      else
        puts "Failed to deserialize: #{$!}"
      end

      return default_value
    end

    def dump(str)
      str.serialize_to_string
    end

    def extract_fields(accessors = nil)
      fields = @klass.fields.values

      if !accessors.nil?
        accessors = accessors.dup.map { |a| a.to_s }
        fields = fields.select { |field|
          accessors.include?(field.name.to_s)
        }
      end

      typed_fields = fields.map do |field|
        t = case field
            when ProtocolBuffers::Field::StringField
              :string
            when ProtocolBuffers::Field::VarintField
              :int
            when ProtocolBuffers::Field::FloatField, ProtocolBuffers::Field::DoubleField
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
