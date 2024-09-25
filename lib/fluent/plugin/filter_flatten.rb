require 'fluent/plugin/filter'

module Fluent::Plugin
  class FlattenFilter < Filter

    Fluent::Plugin.register_filter('flatten', self)

    config_param :enabled, :bool, default: true
    config_param :field, :string, default: ''
    config_param :separator, :string, default: '_'
    config_param :recurse, :bool, default: false

    def initialize
      super
    end

    def configure(conf)
      super

      if @enabled && @separator.include?(".")
        raise Fluent::ConfigError, "Invalid separator: cannot be or contain '.'"
      end

      if @enabled && @recurse
        log.info "Flatten will recurse nested hashes and arrays"
      end

    end

    def filter(tag, time, record)
      begin
        if @enabled
          flatten(record)
        else
          record
        end
      rescue => e
        router.emit_error_event(tag, time, record, e)
      end
    end

    def flatten(record)
      unless @field.to_s.length > 0
        raise Fluent::ConfigError, "Invalid invocation: field not defined"
      end

      newrecord = {}

      record.each do |key, value|
        if key.match(@field)
          newkey = key.gsub(/\./, @separator)
        else
          newkey = key
        end

        # Recurse hashes and arrays:
        if @recurse
          if value.is_a? Hash
            value = flatten value
          elsif value.is_a? Array
            value = value.map { |v| v.is_a?(Hash) ? flatten(v) : v }
          end
        end

        newrecord[newkey] = value
      end

      newrecord
    end

  end
end
