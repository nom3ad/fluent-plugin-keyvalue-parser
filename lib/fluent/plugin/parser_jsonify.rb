require 'fluent/parser'
require 'fluent/log'
require 'fluent/time'


module Fluent
  class TextParser
    class JsonKeyValueParser < Parser

      # Register this parser as "jsonify"
      Plugin.register_parser("jsonify", self)

      config_param :pair_delimiter, :string, :default => " " 
      config_param :key_value_seperator, :string, :default => "," 

      def configure(conf)

        super

        #  if @pair_delimiter.length != 1
        #  raise ConfigError, "delimiter must be a single character. #{@delimiter} is not."
        # end

      end

      def parse(text)
      	$log.debug "recieved text = " + text
        kv_pairs = text.split(@pair_delimiter)
        $log.debug "kv_pairs  = " + kv_pairs.to_s
        record = {}
        kv_pairs.each { |kv|
          k, v = kv.split(@key_value_seperator, 2)
          record[k] = v
        }
        yield nil, record
      end
