import re

def note_notation(string):
	note	= re.search(r"\w", string)[0]
	oct		= re.search(r"\d", string)[0]
	res		= oct + note.upper()
	return res

def Strict(mood):

	preinstr = mood
	preroute = ''

	this_dict = {'INSTR': preinstr, 'ROUTE': preroute}		

	return this_dict	

#------------------------------------------------------
#------------------------------------------------------
#------------------------------------------------------


def Whimsy(mood):

		instr_name		= re.search(r"^@(\w+)", mood)[1]
		instr_scale		= re.search(r"in\s+(\w+)", mood)[1]
		instr_env		= re.search(r"with\s+(\w+)", mood)[1]
		instr_root		= re.search(r"and\s+(\w+):", mood)[1]

		if re.search(r"^@\w+.(.*\))\sin", mood):
			preroute_out_params = re.search(r"^@\w+.\w+\((.*\))\sin", mood)
			preroute_out_name	= re.search(r"^@\w+.(\w+)\(", mood)
		else:
			preroute_out_params = '1'
			preroute_out_name = 'getmeout'

		instr_root	= note_notation(instr_root)
		
		values	= re.search(r":\s+(.*)", mood)[1]

		rhythm = re.findall(r"[^.|\s]+|\.", values)

		rhythm_len = len(rhythm)

		pattern_octave = []
		pattern_note = []
		pattern_dyn = []
		pattern_dur = []

		last_pattern_dyn = '$mf'
		
		for el in rhythm:

			if el != '.':
				#before digit
				if re.search(r"('+)\d+", el):
					how_many = len(re.findall(r"'", el))
					pattern_octave.append(str(1/pow(2, how_many)))
				#after digit
				elif re.search(r"\d+('+)", el):
					how_many = len(re.findall(r"'", el))
					pattern_octave.append(str(1*pow(2, how_many)))
				else:
					pattern_octave.append('1')

				pattern_note.append(re.search(r"\d+", el)[0])
				
				try:
					macro_pattern_dyn = '$' + re.search(r"[a-z]+", el)[0]
					pattern_dyn.append(macro_pattern_dyn)
					last_pattern_dyn = macro_pattern_dyn
				except:
					pattern_dyn.append(last_pattern_dyn)			
				
				#print(el)
				if re.search(r".*-", el):
					how_many = len(re.findall(r"-", el))
					pattern_dur.append('gkbeats*' + str(how_many+1))
				else:
					pattern_dur.append('gkbeats')
			
			else:

				pattern_octave.append('0')
				pattern_note.append('0')
				pattern_dyn.append('0')
				pattern_dur.append('0')			

		preinstr = f'''
ilen		init {rhythm_len}
i_pattern_octave[]	fillarray {', '.join(pattern_octave)}
i_pattern_note[]	fillarray {', '.join(pattern_note)}
i_pattern_dyn[]		fillarray {', '.join(pattern_dyn)}
k_pattern_dur[]		fillarray {', '.join(pattern_dur)}

if changed2:k(i_pattern_note[gkbeatn%ilen]) != 0 then
	eva("{instr_name}", k_pattern_dur[gkbeatn%ilen], i_pattern_dyn[gkbeatn%ilen], gi{instr_env}, pattern_note("{instr_root}", gi{instr_scale}, i_pattern_note[gkbeatn%ilen])*i_pattern_octave[gkbeatn%ilen])
endif
'''

		preroute = f'{preroute_out_name}(\"{instr_name}\", {preroute_out_params})'

		this_dict = {'INSTR': preinstr, 'ROUTE': preroute}		

		return this_dict


#------------------------------------------------------
#------------------------------------------------------
#------------------------------------------------------

def convert_instr_params(line):

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



def Complex(mood):

	complex_list = []

	lines = mood.splitlines()

	inside_adds = []
	instr_lines = []

	for line in lines:
		line = line.strip()
		if line.startswith('+'):
			line = re.sub(r"^\+", '', line)
			inside_adds.append(line)
		else:
			instr_lines.append(line)

	algorithm 			= instr_lines[0]
	algorithm_name		= re.search(r"^(\w+):", algorithm)[1]
	algorithm_params	= re.search(r":\s(.+)", algorithm)[1]

	#LINE 0, algorithm
	#CHECK IF NAME IS IN DICT

	#LINE 1, INSTRUMENT AND ROUTING
	instrument_name_route_line = instr_lines[1]

	#INSTRUMENT LINE HAS 3 ZONES:
	#ZONE_PARAMS @ ZONE_NAMES . ZONE_ROUTES

	#ZONE_PARAMS
	instrument_params = convert_instr_params(instrument_name_route_line) 

	#ZONE_NAMES
	instrument_names = []

	for match in re.finditer(r"@(\w+)", instrument_name_route_line):
		instrument_names.append(match[1])

	#ZONE_ROUTES
	preroute_out_names = []
	preroute_out_params = []

	#IF THERE'S A DOT AND A WORD
	if re.search(r"\.(\w+)", instrument_name_route_line):
		#SEPARATE EACH ROUTE
		for match in re.finditer(r"\.(\w+\(.*?\))(?=(?:\.)|$)", instrument_name_route_line):
			#JUST THE WORD
			preroute_out_names.append(re.search(r"\w+", match[1])[0])
			#EVERYTHING INSIDE PARENTHESIS
			preroute_out_params.append(re.search(r"\((.*)\)", match[1])[1])
	#IF THERE'S NOTHING, GETMEOUT
	else:
		preroute_out_names.append("getmeout")
		preroute_out_params.append("1")

	dur 		= instr_lines[2]
	dyn 		= instr_lines[3]
	env			= instr_lines[4]
	cps 		= []
	for i in range(5, len(instr_lines)):
		cps.append(instr_lines[i])

	add_to_score = "\n".join(inside_adds)
	cps_to_score = ",\n\t".join(cps)

	for instrument_name in instrument_names:
		preinstr =  f'''
{add_to_score}
if {algorithm_name}({algorithm_params}) == 1 then
eva({instrument_params}"{instrument_name}",
{dur},
{dyn},
{env},
{cps_to_score})
endif
	'''		
		route_lines = []
		for ins_route_index, ins_route_name in enumerate(preroute_out_names):
			route_lines.append(f'{ins_route_name}(\"{instrument_name}\", {preroute_out_params[ins_route_index]})')

			preroute = "\n".join(route_lines)	
			
			complex_list.append({'INSTR': preinstr, 'ROUTE': preroute})


	return complex_list
