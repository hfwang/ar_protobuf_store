RAILS_VERSIONS = ["3.2", "4.0", "4.1", "4.2"]
PROTOBUF_SPECS = [
  ["protobuf", "~> 3.0"],
  ["ruby_protobuf", "~> 0.4"]
]

RAILS_VERSIONS.each do |rails|
  PROTOBUF_SPECS.each do |protobuf|
    appraise "rails#{rails}_#{protobuf.first}" do
      gem "rails", "~> #{rails}"
      gem *protobuf
    end
  end
end
