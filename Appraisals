RAILS_VERSIONS = ["3.2", "4.0", "4.1"]
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

# Special case, want one test case for 1.8.7, so we want protobuf = 3.0.0, which
# is the last version that uses rails < 3.2
appraise "rails3.0_protobuf" do
  gem "rails", "~> 3.0"
  gem "protobuf", "= 3.0.0"
end
