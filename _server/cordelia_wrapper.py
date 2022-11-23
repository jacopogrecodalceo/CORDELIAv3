separator = ';≿━━━━━━━━━━━━━━━━━━━━༺❀༻━━━━━━━━━━━━━━━━━━━━≾\n'
# -*- coding: utf-8 -*-

class Wrapper:
	
	def __init__(self):
		self.out		= []
		num				= 24
		self.last_instr = [None]*num
		self.last_route = [None]*num
		self.direction	= ''
		self.instr		= {}

	def wrap(self, direction, instr):

		self.direction	= direction
		self.instr		= instr
		cordelia_instr_num = 500

		if self.direction == 'CORDELIA_from_BRAIN':
			for my_type, with_instr in self.instr.items():
				#here there are all the instrument ready to be wrapped
				if my_type == 'INSTR':
					for index, each_instr in enumerate(with_instr):
						if not each_instr in self.last_instr:
							self.out.append(separator + f'\tinstr {cordelia_instr_num + index}\n{each_instr}\n\tendin\n' + f'\tstart({cordelia_instr_num + index})\n')
							self.last_instr[index] = each_instr

					for index, each_instr in enumerate(self.last_instr):
						if each_instr:
							if not each_instr in with_instr:
								self.out.append(separator + f'\tkill({cordelia_instr_num + index})\n')
								self.last_instr[index] = None

				if my_type == 'ROUTE':
					cordelia_instr_num += len(self.last_instr)
					for index, each_instr in enumerate(with_instr):
						if not each_instr in self.last_route:
							self.out.append(separator + f'\tinstr {cordelia_instr_num + index}\n{each_instr}\n\tendin\n' + f'\tstart({cordelia_instr_num + index})\n')
							self.last_route[index] = each_instr

					for index, each_instr in enumerate(self.last_route):
						if each_instr:
							if not each_instr in with_instr:
								self.out.append(separator + f'\tkill({cordelia_instr_num + index})\n')
								self.last_route[index] = None

		elif self.direction == 'CORDELIA_from_REAPER':
			if self.instr['id'] == 'MOOD_INIT':
				self.out.append(separator + f"\t{self.instr['INSTR']}\n")
			else:	
				self.out.append(separator + f"\tinstr {self.instr['instr_num']}\n{self.instr['INSTR']}\n{self.instr['ROUTE']}\n\tendin\n")
				self.out.append(f"\tschedule {self.instr['instr_num']}, {self.instr['start_pos']}, {self.instr['length']}\n")



		elif self.direction == 'CSOUND_from_CSOUND':
			self.out.append(self.instr)
		
		#print(self.last_instr, self.last_route)
