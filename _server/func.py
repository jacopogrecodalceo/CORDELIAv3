import re, subprocess, os

CORDELIA_PATH = '/Users/j/Documents/PROJECTs/CORDELIA/'

def csound_return_option(sel):

	#adc, dac, inchs, outchs

	list_devices_accepted = os.path.join(CORDELIA_PATH, '_lists/cordelia_devices')

	devices_now = subprocess.run(['csound', '--devices'], capture_output=True, text=True)

	with open(list_devices_accepted) as file:
		devices_lines = file.readlines()    
		devices_lines = [line.rstrip() for line in devices_lines]
		for devices_line in devices_lines:
			options = []
			if re.search(r"--", devices_line):
				options = re.findall(r"(--\S*)", devices_line)
				print(options)
				devices_line = re.search(r"^(.*?)\s+--.*", devices_line)[1]

			for csound_line in devices_now.stderr.splitlines():
				if re.search(devices_line, csound_line):
					if not devices_line.startswith('#'):
						if sel == 'adc':
							if re.search(r"adc", csound_line):
								device_adc = re.search(r"adc\d+", csound_line)[0]
								return ['-i' + device_adc]
						if sel == 'inchs':
							if re.search(r"adc", csound_line):
								device_inchnls = re.search(r"ch:(\d+)", csound_line)[1]
								return device_inchnls
						if sel == 'dac':
							if re.search(r"dac", csound_line):
								device_dac = re.search(r"dac\d+", csound_line)[0]
								if options:
									list = []
									list.append('-o' + device_dac)
									list.extend(options)

									return list
								else: 
									return ['-o' + device_dac]
						if sel == 'outchs':
							if re.search(r"dac", csound_line):
								device_outchnls = re.search(r"ch:(\d+)", csound_line)[1]
								return device_outchnls
