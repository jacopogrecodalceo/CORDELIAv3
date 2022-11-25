import re
from cordelia_global import CORDELIA_PATH

class Lexer:
	
	def __init__(self):
		self.tokens		= []
		self.keywords	= ['edo12']
		self.direction	= ''
		self.data		= ''
		self.reaper_replacement = {
			r"“": '"',
			r"”": '"'
		}
		self.rhythm = []
		with open(CORDELIA_PATH + '/_lists/list_rhythm') as f:
			lines = f.readlines()
			for line in lines:
				self.rhythm.append(re.compile("^" + line.strip()))



	def tokenizer(self, direction, data):
		self.direction = direction
		self.data = data

		if self.direction == 'CORDELIA_from_BRAIN':

			#prevent end of the line for regex
			self.data += '\n'

			#moods division
			moods = re.findall(r"^(.(?:\n|.)*?)\n$", self.data, re.MULTILINE)

			for mood in moods:
				mood = mood.strip()
				words = mood.split()
				for each_word in words:
					if each_word in self.keywords:
						print(each_word)

			for mood in moods:
				lines = []
				for line in mood.splitlines():

					#remove comments
					if not re.match(r"^;", line):
						lines.append(line)

				#parse for number of lines
				if len(lines) == 1:
					if re.match(r"^@", lines[0]):
						self.tokens.append({'id': 'MOOD_WHIMSY', 'score': mood.strip()})					
					else:	
						self.tokens.append({'id': 'MOOD_STRICT', 'score': mood.strip()})
				elif lines:
					self.tokens.append({'id': 'MOOD_COMPLEX', 'score': mood.strip()})



		elif self.direction == 'CORDELIA_from_REAPER':

			if re.match(r"^instr", self.data):
				instr_num = re.search(r"instr_num: (.*?),", self.data)[1]
				start_pos = re.search(r"start_pos: (.*?),", self.data)[1]
				length = re.search(r"length: (.*?),", self.data)[1]
				score = re.search(r"score: (.*)", self.data, re.MULTILINE | re.DOTALL)[1]

				#replace ASCII to utf-8
				for k, v in self.reaper_replacement.items():
					score = re.sub(k, v, score)

				is_complex = False
				for x in self.rhythm:
					if re.match(x, score):
						is_complex = True

				if re.match(r"^@", score):
					self.tokens.append({'id': 'MOOD_WHIMSY', 'instr_num': int(instr_num), 'start_pos': start_pos, 'length': length, 'score': score.strip()})
				elif is_complex:
					self.tokens.append({'id': 'MOOD_COMPLEX', 'instr_num': int(instr_num), 'start_pos': start_pos, 'length': length, 'score': score.strip()})	
				else:
					self.tokens.append({'id': 'MOOD_STRICT', 'instr_num': int(instr_num), 'start_pos': start_pos, 'length': length, 'score': score.strip()})

			else:
				self.tokens.append(self.data)

		elif self.direction == 'CSOUND_from_CSOUND':
			self.tokens.append(self.data)

