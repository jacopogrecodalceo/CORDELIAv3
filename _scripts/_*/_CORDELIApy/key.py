import ctcsound, re

list_devices_accepted = '/Users/j/Documents/PROJECTs/CORDELIA/_scripts/_cordelia_list/cordelia_output_device'

cs = ctcsound.Csound()

def choose_dac():
	cs.setOption('-I')
	cs.setOption('-d')
	cs.start()
	devices_now = cs.audioDevList(True)
	cs.cleanup()
	cs.reset()
	with open(list_devices_accepted) as file:
		lines = file.readlines()
		lines = [line.rstrip() for line in lines]
		for i, v in enumerate(devices_now):
			this_device = devices_now[i]
			for device in lines:
				device_name = re.search(r'(.*)(?:\s|)\[', this_device['device_name'])[1].rstrip()
				if device_name == device:
					dac = this_device['device_id']
					return dac

CORDELIA_dac = '-o' + choose_dac()
print(CORDELIA_dac)
