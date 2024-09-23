# fluent-plugin-dedot_filter

[![Gem Version](https://badge.fury.io/rb/fluent-plugin-dedot_filter.svg)](https://badge.fury.io/rb/fluent-plugin-dedot_filter)
[![Build Status](https://travis-ci.org/lunardial/fluent-plugin-dedot_filter.svg?branch=master)](https://travis-ci.org/lunardial/fluent-plugin-dedot_filter)
[![Maintainability](https://api.codeclimate.com/v1/badges/25c4074425b1bf7a650a/maintainability)](https://codeclimate.com/github/lunardial/fluent-plugin-dedot_filter/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/lunardial/fluent-plugin-dedot_filter/badge.svg)](https://coveralls.io/github/lunardial/fluent-plugin-dedot_filter)
[![downloads](https://img.shields.io/gem/dt/fluent-plugin-dedot_filter.svg)](https://rubygems.org/gems/fluent-plugin-dedot_filter)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

Fluentd Filter plugin to de-dot field name for elasticsearch.

## Usage

```xml
<filter **>
  @type             flatten
  enabled           true
  key               kubernetes.labels
  recurse           false
  separator         _
</filter>
```

## parameters

* `enabled` (default: true)
* `key` (default: '_')
* `recurse` (default: false)
* `separator` (default: '_')

`separator` cannot be or contain '.'.
`recurce` will cause the plugin to recurse through nested structures (hashes and arrays), and flatten in those key-names too.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

