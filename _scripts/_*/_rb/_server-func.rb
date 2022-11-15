#KEYWORD
def convert_macro(line)

end

#RHYTHM
def convert_rhy(line)

end

#CHANNELS
def convert_chn(line)

	if line.match(/^[a-z]/)
		if line.match(/^r\d/)
			line = line.gsub(/^r/, 'oncegen(girot') + ')'
		elsif line.match(/^l\d/)
			line = line.gsub(/^l/, 'oncegen(giline') + ')'
		elsif line.match(/^e\d/)
			line = line.gsub(/^e/, 'oncegen(gieven') + ')'
		elsif line.match(/^o\d/)
			line = line.gsub(/^o/, 'oncegen(giodd') + ')'
		elsif line.match(/^a\d/)
			line = line.gsub(/^a/, 'oncegen(giarith') + ')'
		elsif line.match(/^d\d/)
			line = line.gsub(/^d/, 'oncegen(gidist') + ')'
		end

		if line.match(/^t/)
			line = line.gsub(/^t.*(?=(?:@))/, '')
		else
			line = line.to_s + ", "
		end
	elsif line.match(/^-/)
		if line.match(/^-r\d/)
			line = line.gsub(/^-r/, 'oncegen(-girot') + ')'
		elsif line.match(/^-l\d/)
			line = line.gsub(/^-l/, 'oncegen(-giline') + ')'
		elsif line.match(/^-e\d/)
			line = line.gsub(/^-e/, 'oncegen(-gieven') + ')'
		elsif line.match(/^-o\d/)
			line = line.gsub(/^-o/, 'oncegen(-giodd') + ')'
		elsif line.match(/^-a\d/)
			line = line.gsub(/^-a/, 'oncegen(-giarith') + ')'
		elsif line.match(/^-d\d/)
			line = line.gsub(/^-d/, 'oncegen(-gidist') + ')'
		end
		line = line.to_s + ", "
	end

end

#INSTRUMENT
def convert_ins(line)

end

#DURATION
def convert_dur(line)

end

#DYNAMIC
def convert_dyn(line)
	line.scan(/\w+/).each do |word|
		$CORDELIA_DYN.each do |el|
			if line.include?(el)
				line = line.insert(line.index(el), "$")
			end
		end
	end
	return line
end

#ENVELOPE
def convert_env(line)

end

#FREQUENCY
def convert_cps(line)

end

def check_if_same(array, array_last, index)
	
	if not array_last.include?(array[index])
		if $print_me
			print $SEPARATOR + array[index]
		end
		$UDP.send($SEPARATOR + array[index], 0, $HOST, $CS_PORT)
	end

=begin 
	if score2csound[block_index] != score2csound_last[block_index]
		udp.send(score2csound[block_index], 0, host, cs_port)
	end 
=end

end