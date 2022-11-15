require 'socket'
require_relative __dir__ + "/_cordelia_list/cordelia_access.rb"
require_relative __dir__ + "/_server-func.rb"

$print_me = false
$SEPARATOR = ";≿━━━━━━━━━━━━━━━━━━━━༺❀༻━━━━━━━━━━━━━━━━━━━━≾\n"

$HOST = "localhost"  # Standard loopback interface address (local$HOST)
$PORT = 10015  # $PORT to listen on (non-privileged $PORTs are > 1023)
$CS_PORT = 10000

bufferSize  = 2048

$UDP = UDPSocket.new
#$UDP.connect($HOST, $PORT)
=begin
begin
	$UDP.bind($HOST, $PORT)
rescue Errno::EADDRINUSE =>
	p "HOW?!"
end
=end
$UDP.bind($HOST, $PORT)

#$UDP_fromcsound = $UDPSocket.new

p ("UDP listening")

$CORDELIA_RHY = ["eu", "eujo", "hex", "jex"]
$CORDELIA_MACRO = ["atk", "when", "fill", "once"]
$CORDELIA_DYN = ["fff", "ff", "f", "mf", "mp", "p", "pp", "ppp", "pppp"]

array_len = 16
score2csound, route2csound, score2csound_last, route2csound_last = Array.new(array_len) { [nil] }

while

	#p $UDP_fromcsound.recvfrom(bufferSize/4)

    bytes_address_pair = $UDP.recvfrom(bufferSize)
    message = bytes_address_pair[0]
    address = bytes_address_pair[1]

	code = "\n" + message + "\n\n\nend"

	begin

		#separate each block and put in an array
		block = code.scan(/^(.(?:\n|.)*?)\n$/).flatten

		#for each block put in an array
		block.each_with_index do |block_line, block_index|

			score_num = 575 + (block_index*2)
			route_num = 575 + (block_index*2) + 1

			line = block_line.split(/\n/).reject(&:empty?)

			if line[0].match(/^@/)

				instr_line = line[0].match(/@(.*)/)[1]

				score2csound[block_index] = <<~CS_CSCORE_SYNTHAX
												instr #{score_num.to_s}
											
											#{instr_line}

												endin		
												start(#{score_num.to_s})
											CS_CSCORE_SYNTHAX
			
				check_if_same(score2csound, score2csound_last, block_index)

			elsif line[0].match(/^t/)

				delay = line[0].match(/^t(.*)@/)[1]
				score2csound[block_index] = <<~CS_CSCORE_SYNTHAX
												instr #{score_num.to_s}
											
											#{instr_line}

												endin		
												start(#{score_num.to_s}, #{delay})
											CS_CSCORE_SYNTHAX
			
				check_if_same(score2csound, score2csound_last, block_index)

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
						score2csound[block_index] = <<~CS_CSCORE_SYNTHAX
														instr #{score_num.to_s}

													#{addendum.join("\n")}
														
													if #{rhy_name}(#{rhy_params}) == 1 then
														eva(#{ins_ch}\"#{ins_name}\",
														#{dur},
														#{dyn},
														#{env},
														#{cps.join(",\n\t")})
													endif

														endin
														start(#{score_num.to_s}, #{ins_start})
													CS_CSCORE_SYNTHAX
					else
						score2csound[block_index] = <<~CS_CSCORE_SYNTHAX
														instr #{score_num.to_s}

													#{addendum.join("\n")}
														
														endin
														start(#{score_num.to_s}, #{ins_start})

													CS_CSCORE_SYNTHAX
					end


					route2csound[block_index] = <<~CS_CSCORE_SYNTHAX
													instr #{route_num.to_s}

												#{ins_route_name}(\"#{ins_name}\", #{ins_route_params})

													endin
													start(#{route_num.to_s}, #{ins_start})
												CS_CSCORE_SYNTHAX

					check_if_same(score2csound, score2csound_last, block_index)

					check_if_same(route2csound, route2csound_last, block_index)


				else
					$UDP.send("prints \"WARNING, YOU ARE WRONG IN #{block_index+1} block\"", 0, $HOST, $CS_PORT)
				end
			end
		end

		array_len.times do |block_index|
			
			score_num = 575 + (block_index*2)
			route_num = 575 + (block_index*2) + 1

			if score2csound[block_index] == nil && score2csound_last[block_index] != nil
				score_kill = "\nkill(#{score_num.to_s})\n"
				$UDP.send(score_kill, 0, $HOST, $CS_PORT)
			end

			if route2csound[block_index] == nil && route2csound_last[block_index] != nil
				route_kill = "\nkill(#{route_num.to_s})\n"
				$UDP.send(route_kill, 0, $HOST, $CS_PORT)
			end

			score2csound_last[block_index] = score2csound[block_index]
			route2csound_last[block_index] = route2csound[block_index]

			score2csound[block_index], route2csound[block_index] = nil

		end

	rescue => e

	end
end


$UDP.close