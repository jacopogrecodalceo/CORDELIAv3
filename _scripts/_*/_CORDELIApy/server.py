import ctcsound, socket, sys

from multiprocessing import Process
from path import *
from func import *

HOST = 'localhost'
CS_PORT = 10000
PORT = 10015
BUFFER_SIZE  = 2048


cs = ctcsound.Csound()
udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

def process_udp():

	array_len = 12

	line_instr_num_init = 500
	score_instr_num_init = 1 + line_instr_num_init + array_len
	route_instr_num_init = 1 + score_instr_num_init + array_len

	lines_to_csound = [None] * array_len
	scores_to_csound = [None] * array_len
	routes_to_csound = [None] * array_len

	lines_to_csound_last = [None] * array_len
	scores_to_csound_last = [None] * array_len
	routes_to_csound_last = [None] * array_len

	udp.bind((HOST, PORT))
	print('UDP PORT: ', PORT, 'is ON!')
	while True:

		udp_score = udp.recv(BUFFER_SIZE).decode()

		blocks = []
		separate_each_block(udp_score, blocks)
		
		CORDELIA_lines = []
		CORDELIA_scores = []
		CORDELIA_routes = []
		
		for block in blocks:

			block_lines = []
			separate_each_line(block, block_lines)
			convert_to_cordelia(block_lines, CORDELIA_lines, CORDELIA_scores, CORDELIA_routes)

		wrap_for_csound(line_instr_num_init, CORDELIA_lines, lines_to_csound)
		wrap_for_csound(score_instr_num_init, CORDELIA_scores, scores_to_csound)
		wrap_for_csound(route_instr_num_init, CORDELIA_routes, routes_to_csound)

		send_or_kill(line_instr_num_init, lines_to_csound, lines_to_csound_last)
		send_or_kill(score_instr_num_init, scores_to_csound, scores_to_csound_last)
		send_or_kill(route_instr_num_init, routes_to_csound, routes_to_csound_last)


def process_cs():
	cs_return = cs.setOption('-odac')
	cs_return = cs.compileCsd('/Users/j/Documents/PROJECTs/CORDELIA/_core/cordelia.csd')
	cs.start()
	if cs_return == ctcsound.CSOUND_SUCCESS:
		print('CSOUND is ON!')
		while cs.performBuffer() == 0:
			pass


if __name__ == '__main__':
	p_cs = Process(target=process_cs)
	p_udp = Process(target=process_udp)

	try:
		p_cs.start()
		p_udp.start()
		
		#p_cs.join()
		#p_udp.join()

	except:
		print('CSOUND is OFF!')
		cs.stop()
		cs.cleanup()
		cs.reset()

		print('UDP PORT: ', PORT, 'is OFF!')
		udp.close()

		sys.exit()
