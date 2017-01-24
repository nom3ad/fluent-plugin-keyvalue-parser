# dummy =  {"log"=>"a=b c d=p e f=g j"}
# dummy =  {"log" => "ab cd=1 bat=23"}
# dummy =  {"log"=>"key1:val1###key2:value2###x:somevalue###diff_key:anothervalue"}
#dummy =  {"log"=> "key1=val1,key2=value2,x=somevalue,diff_key=anothervalue"}
#dummy =  {"log"=>"Jan 15 03:27:05 ssg320m-1.flytxt.com SSG320M: NetScreen device_id=JN11F62DEADD  [Root]system-notification-00257(traffic): start_time=\"2017-01-15 03:29:58\" duration=20 policy_id=283 service=tcp/port:9300 proto=6 src zone=Trust dst zone=Untrust action=Permit sent=390 rcvd=0 src=192.168.151.32 dst=192.168.122.1 src_port=45444 dst_port=9300 src-xlated ip=125.17.228.30 port=7321 dst-xlated ip=192.168.122.1 port=9300 session_id=23113 reason=Close - AGE OUT"}
# dummy =  {"log"=>"Jan 13 09:39:07 fg100d.flytxt.com date=2017-01-13,time=09: 42:18,devname=Flytxt,devid=FG100D3G14802969,logid=1059028704,type=utm,subtype=app-ctrl,eventtype=app-ctrl-all,level=information,vd=\"Flytxt_Tran\",appid=10,user=\"\",srcip=192.168.18.12,srcport=17199,srcintf=\"port2\",dstip=111.221.77.147,dstport=40004,dstintf=\"port1\",proto=17,service=\"udp/40004\",sessionid=1004568834,applist=\"Limited_Restriction_Profile\",appcat=\"Collaboration\",app=\"Skype\",action=pass,msg=\"Collaboration: Skype\""}
dummy =  {"log"=>"Jan 20 17:45:22 ssg320m-1.flytxt.com SSG320M: NetScreen device_id=JN11F62DEADD  [Root]system-notification-00257(traffic): start_time=\"2017-01-20 17:48:40\" duration=0 policy_id=194 service=http proto=6 src zone=Trust dst zone=Untrust action=Tunnel (MTN_CONAKRY) sent=0 rcvd=0 src=192.168.125.99 dst=10.13.252.160 src_port=40055 dst_port=80 src-xlated ip=192.168.125.99 port=40055 dst-xlated ip=10.13.252.160 port=80 session_id=24006 reason=Creation"}
# dummy =  {"log"=>"Jan 19 15:13:18 fg100d.flytxt.com date=2017-01-19,time=15: 16:35,devname=Flytxt,devid=FG100D3G14802969,logid=1059028704,type=utm,subtype=app-ctrl,eventtype=app-ctrl-all,level=information,vd=\"Flytxt_Tran\",appid=34039,user=\"\",srcip=192.168.10.74,srcport=51929,srcintf=\"port2\",dstip=172.217.26.170,dstport=80,dstintf=\"port1\",proto=6,service=\"HTTP\",sessionid=1027045169,applist=\"HR_Finance\",appcat=\"Web.Others\",app=\"HTTP.BROWSER_Chrome\",action=pass,hostname=\"fonts.googleapis.com\",url=\"/css?family=Ubuntu:400,700&subset=latin,latin-ext\",msg=\"Web.Others: HTTP.BROWSER_Chrome,\",apprisk=elevated"}
 dummy =  {"log"=>"duration=0 src zone=Trust dst zone=Untrust action=Tunnel (MTN_CONAKRY) sent bytes are=20 rcvd=33 reason=Creation"}
 text = dummy["log"]
#require 'regexp'


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

if key != "" 
	if value != "" then 
		record[key] = value 
	else 
		record[record.keys.last] << delim << key
	end 
end


puts "",""
record.each do |k,v|
	puts k + " >> " + v
end
puts "=" * 30
culprit ="action"
r ="Tunnel \\(.*\\)"
rn = "(?<scavenged>#{r})#{delim}(?<remnants>.*$)"
rule = //.class.new(rn)

record.keys.each_with_index do |k,i|
	if k == culprit
		neighbour_key = record.keys[i+1]
		valstr = [record[k],neighbour_key].join(delim)
		puts "origina : " + valstr
		m=rule.match(valstr)
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

puts "=" * 30

puts "",""
record.each do |k,v|
	puts k + " >> " + v
end