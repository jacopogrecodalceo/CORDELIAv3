chroma = ['c', 'cis', 'd', 'ees', 'e', 'f', 'fis', 'g', 'aes', 'a', 'bes', 'b', "c'"]

tetrachord_base = '222221'

tetrachord = tetrachord_base.split('')

lilypond_file = __dir__ + "/scale_temp"
output_file = __dir__ + "/modes_#{tetrachord_base}.ly"

modes = []

tetrachord.length.times do |r|
	modes << tetrachord.rotate(r)
end

modes = modes.uniq

tetrachord_st = []
tetrachord_name = []

modes.each do |mode|
	semitones = [0]
	st = 0
	mode.each do |note|
		note = note.to_i
		sum = st + note
		semitones << sum
		st = sum
	end
	tetrachord_st << semitones
end

tetrachord_st.each_with_index do |mode, index_mode|
	scale = []
	i = 0
	mode.each do |st|
		scale << chroma[st] + '^"' + modes[index_mode][i].to_s + '"'
		i += 1
	end
	tetrachord_name << scale
end

File.open(output_file, 'w') do |file|
	IO.foreach(lilypond_file) do |line|
		if line=~/---TITLE---/
			file.write(line.gsub(/---TITLE---/, "MODE " + tetrachord_base))
		elsif line=~/---MODE---/
			tetrachord_name.each_with_index do |mode, index|
				file.write("\\time #{tetrachord_name.length+1}/4\n")
				file.write(mode.join(" "))
				file.write(" \\break\n")
			end
		else
			file.write(line)
		end
	end
end

system("lilypond --output=#{__dir__} #{output_file} ")
system("rm -r #{output_file}")