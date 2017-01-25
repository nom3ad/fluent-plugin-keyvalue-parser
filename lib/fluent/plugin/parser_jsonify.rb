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

			config_param :pair_delimiter,      :string, :default => " " 
			config_param :key_value_seperator, :string, :default => "," 
			
			config_param :adjustment_rules            , :default => false do |val|
				rule_hash = false
				if val != ""
					begin
						rule_hash_raw = JSON.parse(val)
					rescue JSON::ParserError => ex
						# Fluent::ConfigParseError, "got incomplete JSON" will be raised
						raise Fluent::ConfigError, "#{ex.class}: #{ex.message}"
					end
					raise Fluent::ConfigError, "adjustment_rules is not a hash" unless rule_hash_raw.is_a?(Hash)
					#rule_hash = make_rule_hash(rule_hash_raw)
					rule_hash = {}
					rule_hash_raw.each do |k,v|
						regx_str = "(?<scavenged>#{v})#{@pair_delimiter}(?<remnants>.*$)"
						rule_regex = //.class.new(regx_str)
						rule_hash[k] = rule_regex
					end
				end
				rule_hash
			end



			def configure(conf)
				super			
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

				if @adjustment_rules 
					record = adjust_record(record)
				end
				yield nil,record
			end



			def adjust_record(record)
				record.keys.each_with_index do |k,i|
					if adjustment_rules.key? k
						$log.debug "adjusting record ... for key : #{k}"
						neighbour_key = record.keys[i+1]
						valstr = [record[k],neighbour_key].join(@pair_delimiter)
						puts "origina : " + valstr
						m = adjustment_rules[k].match(valstr)
						unless m
							puts "no match"
						else
							puts m[0],m[1],m[2]
							m.names.each do |x|
								puts x + " : " + m[x]
							end
							record[k] = m['scavenged']
							remnants = m['remnants']
							record[remnants] = record.delete neighbour_key
						end
					end
				end
				return record
			end

		end
	end
end