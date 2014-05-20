# ar_protobuf_store

[![Gem Version](http://img.shields.io/gem/v/ar_protobuf_store.svg)][gem]
[![Build Status](http://img.shields.io/travis/hfwang/ar_protobuf_store.svg)][travis]
[![MIT license](http://img.shields.io/badge/license-MIT-red.svg)][license]

[gem]: https://rubygems.org/gems/ar_protobuf_store
[travis]: https://travis-ci.org/hfwang/ar_protobuf_store
[license]: https://github.com/hfwang/ar_protobuf_store/blob/master/LICENSE.txt

* [Homepage](https://rubygems.org/gems/ar_protobuf_store)
* [Documentation](http://rubydoc.info/gems/ar_protobuf_store/frames)
* [Email](mailto:hfwang at porkbuns.net)

## Description

Rails/ActiveRecord 3 comes with a cool ActiveRecord::Store feature
that allows for creating a fairly lightweight schema-less
model. However, it uses YAML, which has poor performance and is just
generally silly.

This gem enhances ActiveRecord to allow storing values in a binary Protocol
Buffer blob. This adds a degree of type-safety and schema management without
having to deal with the migration pain of adding and removing columns to a
regular SQL table. (As well as removing the possibility of indexing the internal
values.)

This gem is known to work with the three "major" Ruby Protocol Buffer libraries (here listed in descending order of speed):

* [protobuf](http://rubygems.org/gems/protobuf) ([localshred on Github](https://github.com/localshred/protobuf))
* [ruby-protocol-buffers](http://rubygems.org/gems/ruby-protocol-buffers) ([Codekitchen on Github](https://github.com/codekitchen/ruby-protocol-buffers))
* [ruby_protobuf](http://rubygems.org/gems/ruby_protobuf) ([macks on Github](https://github.com/macks/ruby-protobuf))

## Install

    $ gem install ar_protobuf_store

## Examples

You can call `ar_protobuf_store` similarly to how you would previously have
called store:

```ruby
class FooExtras < ::Protobuf::Message
  # Auto-generated protobuf compiler output here!
end

class FooModel < ActiveRecord::Base
  # The old, YAML-based version would look like:
  # store :extras, :accessors => :foo, :bar

  # The new, protobuf-based version would look like:
  marshal_store :extras, FooExtras
end
```

## Requirements

## Copyright

Copyright (c) 2014 Hsiu-Fan Wang

See {file:LICENSE.txt} for details.
