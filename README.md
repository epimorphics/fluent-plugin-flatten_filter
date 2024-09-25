# fluent-plugin-flatten_filter

[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

Fluentd Filter plugin to de-dot field name for elasticsearch.

## Usage

```xml
<filter **>
  @type             flatten
  enabled           true
  field             app.kubernetes.io/
  recurse           false
  separator         _
</filter>
```

## Parameters

* `enabled` (default: true)
* `field`   Regex of key fields to be flattenned
* `recurse` (default: false)
* `separator` (default: '_')

`separator` cannot be or contain '.'.
`recurce` will cause the plugin to recurse through nested structures (hashes and arrays), and flatten in those key-names too.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

