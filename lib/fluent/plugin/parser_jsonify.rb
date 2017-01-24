require 'fluent/parser'
require 'fluent/log'
require 'fluent/time'
require 'json'


module Fluent
	class TextParser
		class JsonKeyValueParser < Parser

			QUOTE = "\""

			# Register this parser as "jsonify"
			Plugin.register_parser("jsonify", self)

			config_param :pair_delimiter, :string, :default => " " 
			config_param :key_value_seperator, :string, :default => "," 

			def configure(conf)
				super
				#  if @pair_@pair_delimiteiter.length != 1
				#  raise ConfigError, "@pair_delimiteiter must be a single character. #{@@pair_delimiteiter} is not."
				# end
			end

			def parse(text)
				record = {}
				is_at_key =true
				is_quote_open = false
				
				key_name = ""
				value = ""

				text.each_char do |chr| 

					if is_quote_open && chr != QUOTE
						if is_at_key
							key_name << chr
						else
							value << chr
						end
						next
					end

					case chr
					when QUOTE
						is_quote_open = !is_quote_open
						next

					when @pair_delimiter
						if is_at_key
							key_name << chr
							next
						end
						record[key_name] = value
						key_name = ""
						value = ""
						is_at_key = true
						next
					when @key_value_seperator
						if is_at_key then 
							is_at_key = false 
						else
							value << chr
						end
						next
					else
						if is_at_key
							key_name << chr
						else
							value << chr
						end
						next
					end
				end

				if key_name != "" 
					if value != "" then 
						record[key_name] = value 
					else 
						record[record.keys.last] << @pair_delimiter << key_name
					end 
				end

				yield nil,record
			end

		end
	end
end