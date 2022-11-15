import subprocess, re

def return_device(sel):

	#adc, dac, inchs, outchs

	list_devices_accepted = '/Users/j/Documents/PROJECTs/CORDELIA/_lists/cordelia_devices'

	devices_now = subprocess.run(['csound', '--devices'], capture_output=True, text=True)

	with open(list_devices_accepted) as file:
		devices_lines = file.readlines()    
		devices_lines = [line.rstrip() for line in devices_lines]
		for devices_line in devices_lines:
			for csound_line in devices_now.stderr.splitlines():
				if re.search(devices_line, csound_line):
					if sel == 'adc':
						if re.search(r"adc", csound_line):
							device_adc = re.search(r"adc\d+", csound_line)[0]
							return device_adc
					if sel == 'inchs':
						if re.search(r"adc", csound_line):
							device_inchnls = re.search(r"ch:(\d+)", csound_line)[1]
							return device_inchnls
					if sel == 'dac':
						if re.search(r"dac", csound_line):
							device_adc = re.search(r"dac\d+", csound_line)[0]
							return device_adc
					if sel == 'outchs':
						if re.search(r"dac", csound_line):
							device_outchnls = re.search(r"ch:(\d+)", csound_line)[1]
							return device_outchnls

print('-o' + return_device('dac'))
