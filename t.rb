h = {"a"=>1,"b"=>2,"c"=>3,"d"=>4,"e"=>5,"f"=>6,"g"=>7}

h.keys.each_with_index do |k,i|
	if h[k] == 3
		h["x"] =3
		h.delete "f"
		puts h.to_s
	end
	print k + ">" + h[k].to_s+","
end

puts
h.inject({})
puts h.to_s