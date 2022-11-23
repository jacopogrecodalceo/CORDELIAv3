from moods import *

class Parser:
	
	def __init__(self):
		self.out		= {}
		self.tokens		= []
		self.moods		= {
			'MOOD_STRICT': [],
			'MOOD_WHIMSY': [],
			'MOOD_COMPLEX': [],
		}
		self.INSTR = []
		self.ROUTE = []

	def parse(self, direction, tokens):
		self.direction = direction
		self.tokens		= tokens

		if self.direction == 'CORDELIA_from_BRAIN':

			#e.g. self.tokens.append({'id': 'MOOD_WHIMSY', 'is_twin': True, 'score': mood})			
			#each self.tokens is a dict		
			for token in self.tokens:

				try:
					ref_id = 'MOOD_STRICT'
					if token['id'] == ref_id:
						self.moods[ref_id].append(Strict(token['score']))

					ref_id = 'MOOD_WHIMSY'
					if token['id'] == ref_id:
						self.moods[ref_id].append(Whimsy(token['score']))

					ref_id = 'MOOD_COMPLEX'
					if token['id'] == ref_id:
						for each in Complex(token['score']):
							self.moods[ref_id].append(each)
			
				except Exception as e:
					print(e)	
			
			for mood in self.moods.values():
				#mood is a list
				if mood:
					#separate INSTR from ROUTE
					for instr_or_route in mood:
						for k, v in instr_or_route.items():
							if k == 'INSTR':
								if v:
									self.INSTR.append(v)
							elif k == 'ROUTE':
								if v:
									self.ROUTE.append(v)

			self.out = {'INSTR': list(dict.fromkeys(self.INSTR)), 'ROUTE': list(dict.fromkeys(self.ROUTE))}
		



		elif self.direction == 'CORDELIA_from_REAPER':

			reaper_moods = {}
			for token in self.tokens:
				if type(token) is dict:
					try:
						ref_id = 'MOOD_STRICT'
						if token['id'] == ref_id:
							reaper_moods = token | Strict(token['score'])

						ref_id = 'MOOD_WHIMSY'
						if token['id'] == ref_id:
							reaper_moods = token | Strict(token['score'])

						ref_id = 'MOOD_COMPLEX'
						if token['id'] == ref_id:
							for each in Complex(token['score']):
								reaper_moods = token | each
				
					except Exception as e:
						print('Exception in parsing:')
						print(e)	

				else:
					reaper_moods = {'id': 'MOOD_INIT', 'INSTR': token}

			#print(reaper_moods)
			self.out = reaper_moods



		elif self.direction == 'CSOUND_from_CSOUND':
			for token in self.tokens:
				self.out = token
		