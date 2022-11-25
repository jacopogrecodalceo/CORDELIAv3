import socket

def rprint(string):
	RPR_ShowConsoleMsg(string)

def send_to_csound(action):
	s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	s.sendto(action.encode(), ('localhost', 10025))
	s.close()

class Reaper_Tracks():

	def __init__(self):
		self.id = []
		self.name = []
		self.parent = []
		self.num = []
	
	def get(self):

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
				self.id.append(track_id)
				self.name.append(track_name)
				self.num.append(int(RPR_GetMediaTrackInfo_Value(track_id, "IP_TRACKNUMBER")))
				retval, meditem, parname, track_name, var = RPR_GetSetMediaTrackInfo_String(RPR_GetParentTrack(track_id), "P_NAME", 0, 0)
				self.parent.append(track_name)

class Reaper_Items():

	def __init__(self):
		self.id = []
		self.start_pos = []
		self.length = []
		self.note = []
		self.source = []
		self.index = []
		self.take = []

	def get(self, track_id):
		current_pos = RPR_GetCursorPosition()
		item_index = 0
		for each_track in track_id:
			for j in range(RPR_GetTrackNumMediaItems(each_track)):
				item_id = RPR_GetTrackMediaItem(each_track, j)
				self.id.append(item_id)

				item_pos = RPR_GetMediaItemInfo_Value(item_id, "D_POSITION")
				self.index.append(item_index)

				item_index += 1

				if current_pos<=item_pos:
					item_len = RPR_GetMediaItemInfo_Value(item_id, "D_LENGTH")
					self.length.append(item_len)

					take_id = RPR_GetMediaItemTake(item_id, 0)
					self.take.append(take_id)

					start_pos = item_pos-current_pos
					self.start_pos.append(start_pos)

					source, source_type, size = RPR_GetMediaSourceType(RPR_GetMediaItemTake_Source(take_id), '', 512)

					retval, meditem, parname, item_note, var = RPR_GetSetMediaItemInfo_String(item_id, "P_NOTES", 0, 0)
					if not source_type:
						source_type = "NOTE"
						self.note.append(item_note)

					elif source_type == "MIDI":

						ret_val, ret_take, MIDI_notes, ret_cc, ret_sysex = RPR_MIDI_CountEvts(take_id, 0, 0, 0)
						item_midi = []
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

							retval, meditem, parname, track_name, var = RPR_GetSetMediaTrackInfo_String(each_track, "P_NAME", 0, 0)

							item_midi_string = 'evaMIDIk "' + track_name + '", ' + str(note_start-current_pos) + comma + str(note_dur-item_pos) + comma + str(note_vel) + comma + note_env + comma + 'cpstun(1, ' + str(note_pitch) + ', gktuning)'
							item_midi.append(item_midi_string)

						self.note.append('\n'.join(item_midi))
		
					self.source.append(source_type)


tracks = Reaper_Tracks()
items = Reaper_Items()

tracks.get()
items.get(tracks.id)

for i, each in enumerate(items.source):
	if each == 'MIDI':
		rprint(items.note[i])

