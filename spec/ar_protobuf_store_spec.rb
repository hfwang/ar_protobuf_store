require 'spec_helper'
require 'ar_protobuf_store'
require 'protocol_buffers'

describe ArProtobufStore do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).not_to be_empty
  end
end
