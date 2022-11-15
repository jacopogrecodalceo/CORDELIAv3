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



udp.bind((HOST, PORT))
print('UDP PORT: ', PORT, 'is ON!')
cs.setOption("-odac")
cs.compileCsd('/Users/j/Documents/PROJECTs/CORDELIA/_core/cordelia.csd')
cs.start()