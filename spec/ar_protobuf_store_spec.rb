require 'spec_helper'
require 'ar_protobuf_store'
require 'protocol_buffers'

describe ArProtobufStore do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end
end
