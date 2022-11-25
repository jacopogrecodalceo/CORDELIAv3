import socket

def rprint(string):
	RPR_ShowConsoleMsg(string)

def send_to_csound(action):
	s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	s.sendto(action.encode(), ('localhost', 10025))
	s.close()

class from_REAPER():

	def __init__(self):
		self.track_id = []
		self.item = []
	
	def get_track(self):

		is_solo = True
		is_mute = False

		for i in range(RPR_CountTracks(0)):

			track_id = RPR_GetTrack(0, i)

			#get name of the track
			retval, meditem, parname, track_name, var = RPR_GetSetMediaTrackInfo_String(track_id, "P_NAME", 0, 0)
			is_name = bool(track_name.startswith('cor'))

			#CHECK IF TRACK IS A FOLDER: 0=normal, 1=track is a folder parent
			track_depth = RPR_GetMediaTrackInfo_Value(track_id, "I_FOLDERDEPTH")
			if track_depth==1:
				is_mute = bool(RPR_GetMediaTrackInfo_Value(track_id, "B_MUTE"))
				if RPR_AnyTrackSolo(0):
					is_solo = bool(RPR_GetMediaTrackInfo_Value(track_id, "I_SOLO") > 0)
			if is_name and is_solo and not is_mute:
				self.track_id.append(track_id)

	def get_item(self):
		current_pos = RPR_GetCursorPosition()
		for each_track in self.track_id:
			for j in range(RPR_GetTrackNumMediaItems(each_track)):
				item_id = RPR_GetTrackMediaItem(each_track, j)
				item_pos = RPR_GetMediaItemInfo_Value(item_id, "D_POSITION")
				item_index = j
				if current_pos<=item_pos:
					item_len = RPR_GetMediaItemInfo_Value(item_id, "D_LENGTH")
					retval, meditem, parname, item_note, var = RPR_GetSetMediaItemInfo_String(item_id, "P_NOTES", 0, 0)
					take_id = RPR_GetMediaItemTake(item_id, 0)
					source, source_type, size = RPR_GetMediaSourceType(RPR_GetMediaItemTake_Source(take_id), '', 512)

					start_pos = item_pos-current_pos

					if not source_type:
						source_type = 'NOTE'
						self.item.append({'start_pos': start_pos, 'length': item_len, 'score': item_note, 'source': source_type, 'item_index': item_index})

					elif source_type == 'MIDI':

						ret_val, ret_take, MIDI_notes, ret_cc, ret_sysex = RPR_MIDI_CountEvts(take_id, 0, 0, 0)

						for x in range(MIDI_notes):
							note_index = x
							ret_val, ret_take, note_index, selectedOut, mutedOut, startppqposOut, endppqposOut, note_chn, note_pitch, note_vel = RPR_MIDI_GetNote(take_id, note_index, 0, 0, 0, 0, 0, 0, 0)
							ppqdur = endppqposOut-startppqposOut
							note_start = RPR_MIDI_GetProjTimeFromPPQPos(take_id, startppqposOut)
							note_dur = RPR_MIDI_GetProjTimeFromPPQPos(take_id, ppqdur)
							if note_dur <= 0:
								note_dur = .25
							note_vel = float(note_vel)/256
							#RPR_ShowConsoleMsg(str(note_pitch) + ', ' + str(note_vel) + ', ' + str(ppqdur) + ', ' + str(note_dur) + '\n')
							
							if item_note=='':
								note_env = 'giclassic'
							else:
								note_env = str(item_note)
							comma = ", " 

							cs_score = 'evaMIDIk "' + 'fairest3' + '", ' + str(note_start-current_pos) + comma + str(note_dur-item_pos) + comma + str(note_vel) + comma + note_env + comma + 'cpstun(1, ' + str(note_pitch) + ', gktuning)\nturnoff\n'
							self.item.append({'start_pos': start_pos, 'length': item_len, 'score': cs_score, 'source': source_type, 'item_index': item_index})



	def call_me(self):
		self.get_track()
		self.get_item()

reaper_play = False

cor = from_REAPER()
cordelia_instr_num = 700
cordelia_turnoff = []

def on_play():
	global cordelia_instr_num
	global cordelia_turnoff

	cor.call_me()
	send_to_csound(f"turnoff2_i \"heart\", 0, 0")
	send_to_csound(f"schedule \"heart\", 0, -1")
	params = ['instr_num', 'start_pos', 'length', 'score']
	for index, each_item in enumerate(cor.item):
		if each_item['source'] == 'NOTE':
			num = cordelia_instr_num + index + each_item['item_index']
			send_to_csound(f"instr_num: {num}, {params[1]}: {each_item[params[1]]}, {params[2]}: {each_item[params[2]]}, {params[3]}: {each_item[params[3]]}")
			cordelia_turnoff.append(num)
		if each_item['source'] == 'MIDI':
			num = cordelia_instr_num + each_item['item_index']
			send_to_csound(f"instr_num: {cordelia_instr_num + each_item['item_index']}, {params[1]}: {each_item[params[1]]}, {params[2]}: {each_item[params[2]]}, {params[3]}: {each_item[params[3]]}")
			cordelia_turnoff.append(num)


def on_stop():
	global cordelia_turnoff

	#for each_num in range(len(cor.item)):
	#	send_to_csound(f"kill({cordelia_instr_num + each_num})".encode())
	all_instr = []
	for i in cordelia_turnoff:
		all_instr.append('\tturnoff3 ' + str(i) + '\n' + '\tturnoff2 ' + str(i) + ', 0, 0')
	joined = '\n'.join(all_instr)
	send_to_csound(f"\tinstr 695\n{joined}\n\tendin\n\tschedule 695, 0, .05")
	cor.__init__()
	cordelia_turnoff.clear()

def check_play():

	global reaper_play
	
	if RPR_GetPlayState()==1 and not reaper_play:
		on_play()
		pass
		reaper_play = True
	elif RPR_GetPlayState()==0 and reaper_play:
		on_stop()
		reaper_play = False

	RPR_defer('check_play()')



check_play()