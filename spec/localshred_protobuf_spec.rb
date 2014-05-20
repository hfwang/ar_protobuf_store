require "spec_helper"
require "ar_protobuf_store"

begin
  require "protobuf"
  if !Gem.loaded_specs["protobuf"]
    raise LoadError, "Didn't load localshred's ruby_protobuf library!"
  end

  describe "ArProtobufStore::LocalshredSupport" do
    around(:each) do |example|
      setup_db do
        create_table :foos do |t|
          t.column :extras, :binary
        end
      end

      example.run

      teardown_db
    end

    let(:ar_klass) {
      # Define everything using anonymous classes to reduce leakage.
      extras = Class.new(::Protobuf::Message) do
        optional :uint64, :int_attr, 1
        optional :string, :str_attr, 2
      end

      Class.new(::ActiveRecord::Base) do
        self.table_name = "foos"

        include ArProtobufStore

        protobuf_store :extras, extras
      end
    }

    describe ArProtobufStore::ClassMethods do
      it "should allow setting fields individually" do
        record = ar_klass.create!
        record.int_attr = 2
        record.str_attr = "TEST"
        record.save
        expect(record.persisted?).to eq(true)
        record_id = record.id

        record = ar_klass.find(record_id)
        expect(record.int_attr).to eq(2)
        expect(record.str_attr).to eq("TEST")
      end

      it "should allow setting fields in constructor" do
        record = ar_klass.create!(:int_attr => 2, :str_attr => "TEST")
        expect(record.persisted?).to eq(true)
        record_id = record.id

        record = ar_klass.find(record_id)
        expect(record.int_attr).to eq(2)
        expect(record.str_attr).to eq("TEST")
      end
    end
  end
rescue LoadError
  # Ignore: protobuf isn't loaded!
end
