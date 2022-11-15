import re, socket

SCORE_SEPARATOR = ";≿━━━━━━━━━━━━━━━━━━━━༺❀༻━━━━━━━━━━━━━━━━━━━━≾\n"

udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

def prepend_to_score(score):
	score = "\n" + score + "\n\n\nend"

	return score

def gen_instr_index(index):
	res = 500 + (index*12)

	return res

def separate_each_block(score, array): 
	regex = r"^(.(?:\n|.)*?)\n$"
	for match in re.finditer(regex, score, re.MULTILINE):
		array.append(match[1])

def separate_each_line(score, array):
	for each in score.splitlines():
		array.append(each)

def check_if_same(array, array_last, index):
	global SCORE_SEPARATOR
	
	prepare_to_send = SCORE_SEPARATOR + array[index]
	if not array[index] in array_last:
		print(prepare_to_send)
		udp.sendto(prepare_to_send.encode(), (HOST, CS_PORT))
		udp.close()
		#print("ok")