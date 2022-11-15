import re, ctcsound, socket

cs = ctcsound.Csound()
CORDELIA_ALGORITHM = ["eu", "eujo", "hex", "jex"]
SCORE_SEPARATOR = ';≿━━━━━━━━━━━━━━━━━━━━༺❀༻━━━━━━━━━━━━━━━━━━━━≾\n'
PRINT_ME = False
HOST = 'localhost'
CS_PORT = 10000

udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)


def convert_ins_params(line):

	if not line.startswith('@'):

		line = re.search(r"^(.+?)@", line)[1]
		
		if re.search(r"^[a-z]", line):
			if re.search(r"^r\d", line):
				line = re.sub(r"^r", 'oncegen(girot', line) + ')'
			elif re.search(r"^l\d", line):
				line = re.sub(r"^l", 'oncegen(giline', line) + ')'
			elif re.search(r"^e\d", line):
				line = re.sub(r"^e", 'oncegen(gieven', line) + ')'
			elif re.search(r"^o\d", line):
				line = re.sub(r"^o", 'oncegen(giodd', line) + ')'
			elif re.search(r"^a\d", line):
				line = re.sub(r"^a", 'oncegen(giarith', line) + ')'
			elif re.search(r"^d\d", line):
				line = re.sub(r"^d", 'oncegen(gidist', line) + ')'

			elif re.search(r"^t", line):
				line = re.sub(r"^t.*(?=(?:@))", '')
		
		elif re.search(r"^-", line):
			if re.search(r"^-r\d", line):
				line = re.sub(r"^-r", 'oncegen(-girot', line) + ')'
			elif re.search(r"^-l\d", line):
				line = re.sub(r"^-l", 'oncegen(-giline', line) + ')'
			elif re.search(r"^-e\d", line):
				line = re.sub(r"^-e", 'oncegen(-gieven', line) + ')'
			elif re.search(r"^-o\d", line):
				line = re.sub(r"^-o", 'oncegen(-giodd', line) + ')'
			elif re.search(r"^-a\d", line):
				line = re.sub(r"^-a", 'oncegen(-giarith', line) + ')'
			elif re.search(r"^-d\d", line):
				line = re.sub(r"^-d", 'oncegen(-gidist', line) + ')'

		line = line + ', '

	else:
		line = ''

	return line

def separate_each_block(string, array): 
	string = "\n" + string + "\n\n\nend"
	regex = r"^(.(?:\n|.)*?)\n$"
	for match in re.finditer(regex, string, re.MULTILINE):
		array.append(match[1])

def separate_each_line(string, array):
	for each in string.splitlines():
		array.append(each)

def convert_to_cordelia(lines, array_lines, array_scores, array_routes):

	#===========================
	#LINE BLOCK
	#===========================
	#IF ONE LINE
	if len(lines) == 1:
		line = lines[0]

		line_to_csound = []
		#IF STARTS WITH @
		if re.search(r"^@", line):
			line_to_csound = re.sub(r"^@", '', line)
			array_lines.append(line_to_csound)
		else:
			array_lines.append(line_to_csound)

	#IF BLOCK		
	else:

		#EXTRACT FROM LIST IF THERE'S A +
		adds = []
		instr_lines = []
		for line in lines:
			line = line.strip()
			if line.startswith('+'):
				line = re.sub(r"\+", '', line)
				adds.append(line)
			else:
				instr_lines.append(line)

		alg 		= instr_lines[0]
		alg_name	= re.search(r"^(\w+):", alg)[1]
		alg_params	= re.search(r":\s(.+)", alg)[1]

		#LINE 0, ALGORITHM
		#CHECK IF NAME IS IN DICT
		if alg_name in CORDELIA_ALGORITHM:

			#LINE 1, INSTRUMENT AND ROUTING
			ins 		= instr_lines[1]
			
			#INSTRUMENT LINE HAS 3 ZONES:
			#ZONE_PARAMS @ ZONE_NAMES . ZONE_ROUTES

			#ZONE_PARAMS
			ins_params = convert_ins_params(ins) 

			#ZONE_NAMES
			ins_names = []

			for match in re.finditer(r"@(\w+)", ins):
				ins_names.append(match[1])

			#ZONE_ROUTES
			ins_route_names = []
			ins_route_params = []


			#===========================
			#SCORE BLOCK
			#===========================
			#IF THERE'S A DOT AND A WORD
			if re.search(r"\.(\w+)", ins):
				#SEPARATE EACH ROUTE
				for match in re.finditer(r"\.(\w+\(.*?\))(?=(?:\.)|$)", ins):
					#JUST THE WORD
					ins_route_names.append(re.search(r"\w+", match[1])[0])
					#EVERYTHING INSIDE PARENTHESIS
					ins_route_params.append(re.search(r"\((.*)\)", match[1])[1])
			#IF THERE'S NOTHING, GETMEOUT
			else:
				ins_route_names.append("getmeout")
				ins_route_params.append("1")

			dur 		= instr_lines[2]
			dyn 		= instr_lines[3]
			env			= instr_lines[4]
			cps 		= []
			for i in range(5, len(instr_lines)):
				cps.append(instr_lines[i])
		
			add_to_score = "\n".join(adds)
			cps_to_score = ",\n\t".join(cps)

			for ins_name in ins_names:
				line_to_csound =  f'''
{add_to_score}

if {alg_name}({alg_params}) == 1 then
	eva({ins_params}"{ins_name}",
	{dur},
	{dyn},
	{env},
	{cps_to_score})
endif
'''

				array_scores.append(line_to_csound)
			
			#===========================
			#ROUTE BLOCK
			#===========================
			for ins_name in ins_names:
				
				route_lines = []
				for ins_route_index, ins_route_name in enumerate(ins_route_names):
					route_lines.append(f'{ins_route_name}(\"{ins_name}\", {ins_route_params[ins_route_index]})')

					line_to_csound = "\n".join(route_lines)
					
					#REMOVE DUPLICATES
					seen = set()
					for i, e in enumerate(route_lines):
						if e in seen:
							route_lines[i] = None
						else:
							seen.add(e)

					array_routes.append(line_to_csound)


def wrap_for_csound(init, blocks, array):
	for index, lines in enumerate(blocks):
		if lines:
			instr_num = str(index + init)
			wrap_instr = '\tinstr ' + instr_num  + '\n' + lines + '\n\tendin'
			wrap_instr += f'\n\tstart({instr_num})\n'
			array[index] = wrap_instr



def send_to_csound(message):

	global SCORE_SEPARATOR
	global PRINT_ME

	message = SCORE_SEPARATOR + message
	
	if PRINT_ME:
		print(message)
	cs.compileOrc(message)
	#udp.sendto(message.encode(), (HOST, CS_PORT))



def send_or_kill(init, array, array_last):
	for index in range(len(array_last)):
		instr_num = str(index + init)

		if not array[index] and array_last[index]:
			score_kill = f'\tkill({instr_num})\n'
			send_to_csound(score_kill)
		elif array[index]:
			if not array[index] in array_last:
				send_to_csound(array[index])

		array_last[index] = array[index]

		array[index] = None
