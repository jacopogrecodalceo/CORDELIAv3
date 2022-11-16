import socket

def rprint(string):
	RPR_ShowConsoleMsg(string)

def send_to_csound(action):
	s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	s.sendto(action, ('localhost', 10025))
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
				if current_pos<=item_pos:
					item_len = RPR_GetMediaItemInfo_Value(item_id, "D_LENGTH")
					retval, meditem, parname, item_note, var = RPR_GetSetMediaItemInfo_String(item_id, "P_NOTES", 0, 0)
					take_id = RPR_GetMediaItemTake(item_id, 0)
					source, source_type, size = RPR_GetMediaSourceType(RPR_GetMediaItemTake_Source(take_id), '', 512)

					if not source_type:
						source_type = 'NOTE'

					start_pos = item_pos-current_pos

				self.item.append({'start_pos': start_pos, 'length': item_len, 'score': item_note, 'source': source_type})

	def call_me(self):
		self.get_track()
		self.get_item()

reaper_play = False

cor = from_REAPER()

def on_play():
	cor.call_me()
	params = ['instr_num', 'start_pos', 'length', 'score']
	for index, each_item in enumerate(cor.item):
		send_to_csound(f"instr_num: {index}, {params[1]}: {each_item[params[1]]}, {params[2]}: {each_item[params[2]]}, {params[3]}: {each_item[params[3]]}".encode())

def on_stop():
	cordelia_instr_num = 500
	for each_num in range(len(cor.item)):
		send_to_csound(f"kill({cordelia_instr_num + each_num})".encode())
	cor.__init__()

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