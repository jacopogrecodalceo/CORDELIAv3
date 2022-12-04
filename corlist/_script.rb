title			= File.basename(__dir__)

score_path		= __dir__ + '/_' + title + '-score_scripted.csd'
opt_path		= __dir__ + '/_' + title + '-opt'

score_file = File.open(score_path, 'w')
opt_file = File.open(opt_path, 'w')

ref_string =";\t\twhen\tfile\t\t\t\tstart\tloop\tgain\tfadin\tmode\tfadout\tmode"

section_array = []
maximum_ch = []


Dir.glob(__dir__ + '/*.wav') do |f|
	name = File.basename(f)
	section_array << name

	ch = `soxi -c #{f}`.strip
	maximum_ch << ch
end

section_array = section_array.sort

csound_instance_div = 1000.0

csound_score_instr_num = 1.0

default = ";turnoff_i all instances (0), oldest only (1), or newest only (2), notes with exactly matching (fractional) instrument(4)\n"

score_file.write(ref_string + "\n")

section_array.each_with_index do |f, i|

	index = i + 1
	schedule = "schedule #{csound_score_instr_num + index/csound_instance_div},\t0, 1, \"#{f}\",\t\t0,\t0,\t.5,\t5125,\t0,\t5125,\t0\n"
	score_file.write(schedule)

	turnoff = "turnoff2_i #{csound_score_instr_num + index/csound_instance_div}, 4, 1\n"
	score_file.write(turnoff)

end

score_file.write(default)

score_file.close unless score_file.nil?

opt_file.write("nchnls = #{maximum_ch.max}")