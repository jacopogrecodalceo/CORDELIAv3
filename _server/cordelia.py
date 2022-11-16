import socket, select, ctcsound
from threading import Thread
from datetime import datetime 

from cordelia_lexer import Lexer
from cordelia_parser import Parser
from cordelia_wrapper import Wrapper
from func import *

cs = ctcsound.Csound()

TODAY = datetime.today().strftime('%y%m%d-%H%M')
CORDELIA_PATH = '/Users/j/Documents/PROJECTs/CORDELIA/'

#add new ports here
cordelia_ports = {
	10015: 'CORDELIA_from_BRAIN',
	10000: 'CSOUND_from_CSOUND',
	10025: 'CORDELIA_from_REAPER',
	10005: 'CSOUND_from_REAPER'
	}

sockets = []

for port, name in cordelia_ports.items():
	server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	server_socket.bind(('localhost', port))
	print(f"Hello {name}")
	sockets.append(server_socket)

empty = []
lexer = Lexer()
parser = Parser()
wrapper = Wrapper()

UDP_size = 1024

def UDP_receive():
	print('UDPs are ready')
	while True:
		readable, writable, exceptional = select.select(sockets, empty, empty)
		for s in readable:		
			#get where the message comes from
			_host, port = s.getsockname()
			direction = cordelia_ports[port]
			print(f"\n---I come from {direction}\n")

			#get UDP message
			score, _address = s.recvfrom(UDP_size)

			try:
				lexer.tokenizer(direction, score.decode())
				parser.parse(direction, lexer.tokens)
				wrapper.wrap(direction, parser.out)
				for each in wrapper.out:
					pass
					print(each)
					cs.compileOrcAsync(each)
					
				lexer.__init__()
				parser.__init__()
				wrapper.out.clear()

			except Exception as e:
				print(e)	

def open_cordelia():
	for v in csound_return_option('dac'):
		print(v + "\n")
		cs.setOption(v)	
	cs.compileOrc(f'#define CORDELIA_PATH #{CORDELIA_PATH}#')
	CORDELIA_WAV = CORDELIA_PATH + '_score/cor' + TODAY + '.wav'
	CORDELIA_ORC = CORDELIA_PATH + '_score/cor' + TODAY + '.orc'
	cs.compileOrc(f'#define out_wav #"{CORDELIA_WAV}"#')
	cs.compileOrc(f'#define out_orc #"{CORDELIA_ORC}"#')
	CORDELIA_CSD = CORDELIA_PATH +'_core/cordelia.csd'
	cs.compileCsd(CORDELIA_CSD)
	
	return cs.start()

if __name__ == '__main__':
	
	t = Thread(target=UDP_receive, daemon=True)
	cs_return = open_cordelia()
	if cs_return == ctcsound.CSOUND_SUCCESS:
		print('CSOUND is ON!')
		t.start()
		while cs.performKsmps() == 0:
			pass
		cs.cleanup()
		print('CSOUND is OFF!')

""" if __name__ == '__main__':
	
	t = Thread(target=UDP_receive)
	t.start() """
