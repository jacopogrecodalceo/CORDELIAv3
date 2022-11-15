require 'socket'
require_relative __dir__ + "/_cordelia_list/cordelia_access.rb"

print_me = true

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

host = "localhost"  # Standard loopback interface address (localhost)
port = 10015  # Port to listen on (non-privileged ports are > 1023)
cs_port = 10000

bufferSize  = 2048

udp = UDPSocket.new
#udp.connect(host, port)

udp.bind(host, port)

#udp_fromcsound = UDPSocket.new

p ("UDP listening")

$CORDELIA_RHY = ["eu", "eujo", "hex"]
$CORDELIA_MACRO = ["atk", "when", "fill", "once"]
$CORDELIA_DYN = ["fff", "ff", "f", "mf", "mp", "p", "pp", "ppp", "pppp"]

array_len = 10
score2csound, route2csound, score2csound_last, route2csound_last = Array.new(array_len) { [nil] }

while

	#p udp_fromcsound.recvfrom(bufferSize/4)

    bytes_address_pair = udp.recvfrom(bufferSize)
    message = bytes_address_pair[0]
    address = bytes_address_pair[1]

	full_code = "\n" + message + "\n\n\nend"

	#separate each track and put in an array
	track = full_code.scan(/^(.(?:\n|.)*?)\n$/).flatten

	#for each track put in an array
	track.each_with_index do |track_line, track_index|

		score_num = 575 + (track_index*2)
		route_num = 575 + (track_index*2) + 1

		line = track_line.split(/\n/).reject(&:empty?)
		print line 
		
		if line[0].match(/^@/)

			instr_line = line[0].match(/@(.*)/)[1]

			score2csound[track_index] = instr_line
		
			if score2csound[track_index] != score2csound_last[track_index]
				udp.send(score2csound[track_index], 0, host, cs_port)
			end

		elsif line[0].match(/^schedule/)

			score2csound[track_index] = instr_line
		
			if score2csound[track_index] != score2csound_last[track_index]
				udp.send(score2csound[track_index], 0, host, cs_port)
			end

		elsif line[0].match(/^t/)

			delay = line[0].match(/^t(.*)@/)[1]

			score2csound[track_index] = instr_line
		
			if score2csound[track_index] != score2csound_last[track_index]
				udp.send(score2csound[track_index], 0, host, cs_port)
			end

		else

			addendum = []
			line.each_with_index do |l, i| 
				if l.strip.start_with?('+') 
					line.delete_at(i)
					addendum.append(l.match(/\s+\+(.*)/)[1])
					#print addendum
				end
			end

			rhy = line[0]
			ins = line[1].match(/\s+(.*)/)[1]
			dur = line[2].match(/\s+(.*)/)[1]
			dyn = line[3].match(/\s+(.*)/)[1]
			env = line[4].match(/\s+(.*)/)[1]
			cps = []
			line[5..line.length].each do |cps_line| 
				cps.append(cps_line.match(/\s+(.*)/)[1])
			end

			rhy_name = rhy.match(/^(\w+):/)[1]
			rhy_params = rhy.match(/:\s?(.+)/)[1]
			
			ins_start = "0"
			ins_ch = ins.match(/(.*)@/)[1]
			if ins_ch != ""
				ins_ch = convert_chn(ins_ch)
				if ins_ch.match(/^t/)
					ins_start = ins_ch.gsub(/^t/, '')
					ins_ch = ''
				end
			end
			#p ins_ch

			#if there's . 
			if ins.match(/@\w+(.)/)[1] == '.'
				ins_name = ins.match(/@(\w+)./)[1]
				ins_route_name = ins.match(/@\w*.(.*?)\(/)[1]
				ins_route_params = ins.match(/@.+?\((.*)\)/)[1]
			elsif ins.match(/@\w+(.)/)[1] == '('
				ins_name = ins.match(/@(\w+)\(/)[1]
				ins_route_name = "getmeout"
				ins_route_params = ins.match(/@.+?\((.*)\)/)[1]
			else
				ins_name = ins.match(/@(\w+)/)[1]
				ins_route_name = "getmeout"
				ins_route_params = "1"
			end	

			#check with funcion
			#dyn = convert_dyn(dyn)

			if $CORDELIA_RHY.include?(rhy_name)

				if rhy_name != ""
					score2csound[track_index] = "
#{addendum.join("\n")}
	
if #{rhy_name}(#{rhy_params}) == 1 then
	eva(#{ins_ch}\"#{ins_name}\",
	#{dur},
	#{dyn},
	#{env},
	#{cps.join(",\n\t")})
endif
"
				else
					score2csound[track_index] = "
#{addendum.join("\n")}
					"
				end


				route2csound[track_index] = "
#{ins_route_name}(\"#{ins_name}\", #{ins_route_params})

"

				if score2csound[track_index] != score2csound_last[track_index]
					udp.send(score2csound[track_index], 0, host, cs_port)
				end

				if route2csound[track_index] != route2csound_last[track_index]
					udp.send(route2csound[track_index], 0, host, cs_port)
				end

			else
				udp.send("prints \"WARNING, YOU ARE WRONG IN #{track_index+1} TRACK\"", 0, host, cs_port)
			end
		end
	end

	array_len.times do |track_index|
		
		score_num = 575 + (track_index*2)
		route_num = 575 + (track_index*2) + 1

		if score2csound[track_index] == nil && score2csound_last[track_index] != nil
			score_kill = "\nkill(#{score_num.to_s})\n"
			udp.send(score_kill, 0, host, cs_port)
		end

		if route2csound[track_index] == nil && route2csound_last[track_index] != nil
			route_kill = "\nkill(#{route_num.to_s})\n"
			udp.send(route_kill, 0, host, cs_port)
		end

		if print_me
			print score2csound[track_index]
		end

		score2csound_last[track_index] = score2csound[track_index]
		route2csound_last[track_index] = route2csound[track_index]

		score2csound[track_index], route2csound[track_index] = nil

	end
end