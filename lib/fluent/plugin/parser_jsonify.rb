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
				record = {}
				tokens = text.split(@pair_delimiter)
				is_quote_open = false
				key_name = ""
				value = ""
				tokens.each_with_index do |item,idx|
					if item.split(@key_value_seperator,2)[1].nil?

						if is_quote_open
							if item[-1] == "\""
								#puts "end quote_found" + " at " + item
								value << (@pair_delimiter + item[0..-2])
								is_quote_open = false
								record[key_name] = value
								value = "";key_name = ""
							else
								value << (@pair_delimiter + item)
							end
						else
							key_name << (item + @pair_delimiter)
						end

					else
						k,v = item.split(@key_value_seperator,2)
						key_name << k
						if v[0] == "\""
							is_quote_open = true
							if v[-1] == "\""
								is_quote_open = false
								value << v[1..-2]
								record[key_name] = value
								value = "";key_name = ""
							else
								value << v[1..-1]
							end
						else
							is_quote_open = false
							value << v
							record[key_name] = value
							value = "";key_name = ""
						end
					end
				end

				# append unparsed tail item to last key
				record[record.keys.last] << (@pair_delimiter + key_name)
				#$log.debug "gonna emit this record: " + record.to_s + " when ticks at " + time.to_s
				yield nil, record
			end
		end
	end
end