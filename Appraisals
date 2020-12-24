RAILS_VERSIONS = ["3.2", "4.0.0", "4.1.0", "4.2.0", "4.2.6", "5.0.1", "5.1.3", "5.2.4.4", "6.0.3.4", "6.1.0"]
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
