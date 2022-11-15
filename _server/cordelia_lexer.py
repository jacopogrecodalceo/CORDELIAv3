import re

class Lexer:
	
	def __init__(self):
		self.tokens		= []
		self.keywords	= ['edo12']
		self.direction	= ''
		self.data		= ''

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
						self.tokens.append({'id': 'MOOD_WHIMSY', 'is_twin': True, 'score': mood.strip()})					
					else:	
						self.tokens.append({'id': 'MOOD_STRICT', 'is_twin': True, 'score': mood.strip()})
				elif lines:
					self.tokens.append({'id': 'MOOD_COMPLEX', 'is_twin': True, 'score': mood.strip()})
		
		elif self.direction == 'CORDELIA_from_REAPER':
			#prevent end of the line for regex
			self.data += '\n'

			#moods division
			moods = re.findall(r"^(.(?:\n|.)*?)\n$", self.data, re.MULTILINE)

		elif self.direction == 'CSOUND_from_CSOUND':
			self.tokens.append(self.data)
