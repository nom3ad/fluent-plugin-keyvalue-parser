k = ""
log = "I'm bat man=\"bruce thomas wayne\" I'm super man=\"clark Joseph kent\" hey=aloha"

log ="start_time=\"2017-01-15 03:29:58\" duration=20 policy_id=283 service=tcp/port:9300 proto=6 src zone=Trust dst zone=Untrust action=Permit sent=390 rcvd=0 src=192.168.151.32 dst=192.168.122.1 src_port=45444 dst_port=9300 src-xlated ip=125.17.228.30 port=7321 dst-xlated ip=192.168.122.1 port=9300 session_id=23113 reason=Close - AGE OUT"
puts log
pair_delimiter = " "
key_value_seperator = "="
record = {}
is_quote_open = false

puts k

l = log.split(pair_delimiter)
is_quote_open = false
key_name = ""
value = ""
l.each_with_index do |item,idx|
	if item.split(key_value_seperator,2)[1].nil?

		if is_quote_open
			if item[-1] == "\""
				#puts "end quote_found" + " at " + item
				value << (pair_delimiter + item[0..-2])
				is_quote_open = false
				record[key_name] = value
				value = "";key_name = ""
			else
				value << (pair_delimiter + item)
			end
		else
			key_name << (item + pair_delimiter)
		end

	else
		k,v = item.split(key_value_seperator,2)
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

record.each do |k,v|
	puts k  + " : " + v
end