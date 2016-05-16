require "spec_helper"
require "ar_protobuf_store"

begin
  require "protobuf/message/message"
  require "protobuf/message/enum"
  require "protobuf/message/service"
  require "protobuf/message/extend"
  if !Gem.loaded_specs["ruby_protobuf"]
    raise LoadError, "Didn't load macks' ruby_protobuf library!"
  end

  describe "ArProtobufStore::MacksSupport" do
    around(:each) do |example|
      setup_db do
        create_table :foos do |t|
          t.column :extras, :binary
        end
      end

      example.run

      teardown_db
    end

    def pb_class
      Class.new(::Protobuf::Message) do
        optional :uint64, :int_attr, 1
        optional :string, :str_attr, 2
      end
    end

    let :ar_class do
      # Define everything using anonymous classes to reduce leakage.
      pb_class = self.pb_class

      Class.new(::ActiveRecord::Base) do
        self.table_name = "foos"

        include ArProtobufStore

        protobuf_store :extras, pb_class
      end
    end

    describe ArProtobufStore::ClassMethods do
      it "should allow setting fields individually" do
        record = ar_class.create!
        record.int_attr = 2
        record.str_attr = "TEST"
        record.save
        expect(record.persisted?).to eq(true)
        record_id = record.id

        record = ar_class.find(record_id)
        expect(record.int_attr).to eq(2)
        expect(record.str_attr).to eq("TEST")
      end

      it "should allow setting fields in constructor" do
        record = ar_class.create!(:int_attr => 2, :str_attr => "TEST")
        expect(record.persisted?).to eq(true)
        record_id = record.id

        record = ar_class.find(record_id)
        expect(record.int_attr).to eq(2)
        expect(record.str_attr).to eq("TEST")
      end

      it "should allow required fields" do
        pb_class = Class.new(::Protobuf::Message) do
          optional :uint64, :int_attr, 1
          required :string, :req_str_attr, 2
        end
        ar_class = Class.new(::ActiveRecord::Base) do
          self.table_name = "foos"

          include ArProtobufStore

          protobuf_store :extras, pb_class
        end

        # Handle batch create:
        record = ar_class.create!(:int_attr => 2, :req_str_attr => "required")
        expect(record.persisted?).to eq(true)

        record_id = record.id
        record = ar_class.find(record_id)
        expect(record.int_attr).to eq(2)
        expect(record.req_str_attr).to eq("required")

        # Handle calling setters:
        record.req_str_attr = "something"
        record.save!
        record = ar_class.find(record_id)
        expect(record.req_str_attr).to eq("something")
      end

      it "should respect nil default value" do
        pb_class = self.pb_class
        ar_class = Class.new(::ActiveRecord::Base) do
          self.table_name = "foos"

          include ArProtobufStore

          protobuf_store :extras, pb_class, :default => nil
        end

        # Handle batch create:
        record = ar_class.create!
        expect(record.persisted?).to eq(true)
        expect(record.extras).to eq(nil)

        record_id = record.id
        record = ar_class.find(record_id)
        expect(record.extras).to eq(nil)
      end

      it "should respect default proc" do
        pb_class = self.pb_class
        ar_class = Class.new(::ActiveRecord::Base) do
          self.table_name = "foos"

          include ArProtobufStore

          protobuf_store :extras, pb_class, :default => Proc.new { pb_class.new(int_attr: 2) }
        end

        # Handle batch create:
        record = ar_class.create!
        expect(record.persisted?).to eq(true)
        expect(record.int_attr).to eq(2)

        record.str_attr = "TEST"
        record.save!

        record_id = record.id
        record = ar_class.find(record_id)
        expect(record.int_attr).to eq(2)
        expect(record.str_attr).to eq("TEST")
      end
    end
  end
rescue LoadError
  # Ignore: protobuf isn't loaded!
end
