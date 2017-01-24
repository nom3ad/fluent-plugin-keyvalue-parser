text = "action=alow type=tunel (africa) site=CA sts=OK"

#require 'regexp'

culprit ="type"
rule = 
is_at_key =true
is_quote_open = false
is_escaped = false
quote = "\""
delim = " "
sepertor = "="
key = ""
value = ""
escape = "\\"
record = {}
text.each_char do |chr| 

	# if chr == escape
	# 	is_escaped =true
	# 	next
	# end

	if chr == quote
		is_quote_open = !is_quote_open
		next
	end
	if is_quote_open
		if is_at_key
			key << chr
		else
			value << chr
		end
		next
	else 
		if chr == delim
			if is_at_key
				key << chr
				next
			end
			record[key] = value
			key = ""
			value = ""
			is_at_key = true
			next
		elsif chr == sepertor
			if is_at_key then 
				is_at_key = false 
			else
				value << chr
			end
		else
			if is_at_key
				key << chr
			else
				value << chr
			end
		end
	end
end
if key != "" then record[key] = value end 

r ="tunel \\(.*\\)"
rule = //.class.new(r)

record.keys.each_with_index do |k,i|
	if k == culprit
		valstr = [record[k],record.keys[i+1]].join(delim)
		puts valstr
		m=rule.match(valstr)
		unless m
			puts "no match"
		else
			puts m[0]
		end
	end
end


# puts "",""
# record.each do |k,v|
# 	puts k + " >> " + v
# end