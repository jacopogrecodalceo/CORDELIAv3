import re, socket

from path import *

PRINT_ME = True

HOST = "localhost"  # Standard loopback interface address (local$HOST)
PORT = 10015  # $PORT to listen on (non-privileged $PORTs are > 1023)
CS_PORT = 10000
BUFFER_SIZE  = 2048

CORDELIA_ALGORITHM = ["eu", "eujo", "hex", "jex"]

array_len = 12

score_to_csound = [None] * array_len
route_to_csound = [None] * array_len
score_to_csound_last = [None] * array_len
route_to_csound_last = [None] * array_len

SCORE_SEPARATOR = ";≿━━━━━━━━━━━━━━━━━━━━༺❀༻━━━━━━━━━━━━━━━━━━━━≾"

udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

#=========================================================================================		
#=========================================================================================		
#=========================================================================================		

def send_to_udp(message):
	if PRINT_ME:
		print(message)
	udp.sendto(message.encode(), (HOST, CS_PORT))

def prepend_to_score(score):
	score = "\n" + score + "\n\n\nend"

	return score

def gen_instr_index(index):
	sco = 500 + (index*array_len)
	rou = 500 + (index*array_len) +int(array_len/2)
	return sco, rou

def separate_each_block(score, array): 
	regex = r"^(.(?:\n|.)*?)\n$"
	for match in re.finditer(regex, score, re.MULTILINE):
		array.append(match[1])

def separate_each_line(score, array):
	for each in score.splitlines():
		array.append(each)

def check_if_same(array, array_last, index):
	
	add_separator = SCORE_SEPARATOR + array[index]

	if not array[index] in array_last:
		send_to_udp(add_separator)
		#udp.close()
		#print("ok")

def convert_ins_params(line):
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

	return line

#=========================================================================================		
#=========================================================================================		
#=========================================================================================		

with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as udp:
	udp.bind((HOST, PORT))
	print('Connected by', PORT)
	while True:

		score = udp.recv(BUFFER_SIZE).decode()
		
		score = prepend_to_score(score)

		blocks = []
		separate_each_block(score, blocks)
		
		for block_index, block in enumerate(blocks):

			score_num, route_num = gen_instr_index(block_index)

			block_lines = []
			separate_each_line(block, block_lines)

			#IF ONE LINE
			if len(block_lines) == 1:
				line = block_lines[0]

				#IF STARTS WITH @
				if re.search(r"^@", line):
					line = re.sub(r"^@", '', line)
					score_to_csound[block_index] =  f'''
	instr {score_num}
{line}
	endin
	start({score_num})
'''

					check_if_same(score_to_csound, score_to_csound_last, block_index)

			#IF BLOCK		
			else:

				#EXTRACT FROM LIST IF THERE'S A +
				adds = []
				lines = []
				for index, line in enumerate(block_lines):
					line = line.strip()
					if line.startswith('+'):
						line = re.sub(r"\+", '', line)
						adds.append(line)
					else:
						lines.append(line)

				alg 		= lines[0]
				alg_name	= re.search(r"^(\w+):", alg)[1]
				alg_params	= re.search(r":\s?(.+)", alg)[1]

				#LINE 0, ALGORITHM
				#CHECK IF NAME IS IN DICT
				if alg_name in CORDELIA_ALGORITHM:

					#LINE 1, INSTRUMENT AND ROUTING
					ins 		= lines[1]
					
					#INSTRUMENT LINE HAS 3 ZONES:	ZONE_PARAMS @ ZONE_NAMES . ZONE_ROUTES

					#ZONE_PARAMS
					if not ins.startswith('@'):
						ins_params = re.search(r"^(.+?)@", ins)[1]
						ins_params = convert_ins_params(ins_params) + ', '
					else:
						ins_params = '' 
					#print(ins_params)
					ins_start = '0'

					#ZONE_NAMES
					ins_names = []

					for match in re.finditer(r"@(\w+)", ins):
						ins_names.append(match[1])
					#print(ins_name)

					#ZONE_ROUTES
					ins_route_names = []
					ins_route_params = []

					if re.search(r"\.(.*?\))(\.|$)", ins):
						for match in re.finditer(r"\.(.*?\))(\.|$)", ins):
							ins_route_names.append(re.search(r"\w+", match[1])[0])
							ins_route_params.append(re.search(r"\((.*)\)", match[1])[1])
					#IF THERE'S NOTHING, PUT GETMEOUT
					else:
						ins_route_names.append("getmeout")
						ins_route_params.append("1")

					#print(ins_route_names, ins_route_params)

					dur 		= lines[2]
					dyn 		= lines[3]
					env			= lines[4]
					cps 		= []
					for i in range(5, len(lines)):
						cps.append(lines[i])
				
					insert_score_adds = "\n".join(adds)
					insert_score_cps = ",\n\t".join(cps)

					for ins_index, ins_name in enumerate(ins_names):
						score_num = score_num + ins_index
						score_to_csound[block_index + ins_index] =  f'''
	instr {score_num}

{insert_score_adds}
	
if {alg_name}({alg_params}) == 1 then
	eva({ins_params}"{ins_name}",
	{dur},
	{dyn},
	{env},
	{insert_score_cps})
endif

	endin
	start({score_num}, {ins_start})
'''

						check_if_same(score_to_csound, score_to_csound_last, block_index + ins_index)


					for ins_index, ins_name in enumerate(ins_names):
						route_num = route_num + ins_index
						
						route_block = []
						for ins_route_index, ins_route_name in enumerate(ins_route_names):
							route_block.append(f'{ins_route_name}(\"{ins_name}\", {ins_route_params[ins_route_index]})')

							insert_route = "\n".join(route_block)
							route_to_csound[block_index + ins_index] =  f'''
	instr {route_num}

{insert_route}

	endin
	start({route_num}, {ins_start})
'''
			
						check_if_same(route_to_csound, route_to_csound_last, block_index + ins_index)


		for index in range(array_len):

			score_num, route_num = gen_instr_index(block_index)

			if not score_to_csound[index] and score_to_csound_last[index]:
				score_kill = f'\tkill({score_num})\n'
				send_to_udp(score_kill)
				
			score_to_csound_last[index] = score_to_csound[index]

			score_to_csound[index] = None

			if not route_to_csound[index] and route_to_csound_last[index]:
				route_kill = f'\tkill({route_num})\n'
				send_to_udp(route_kill)
				
			route_to_csound_last[index] = route_to_csound[index]

			route_to_csound[index] = None



