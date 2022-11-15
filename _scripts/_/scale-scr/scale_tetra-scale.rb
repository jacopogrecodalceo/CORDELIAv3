the_modes = { }
scale_file = __dir__ + "/scale.orc"

File.readlines(scale_file).each do |line|
    #p line
	if line=~/^\w/ 
		the_key = line.match(/^\w+/)[0]
		
		the_val = line.match(/ftgen\s+\d,\s+\d,\s+\d,\s+-2,\s(.*)/)[1]

		the_modes[the_key] = the_val

	end

end

checkdup = []

the_modes.each do |key, array|
    array = array.strip.split(', ')
    checkdup << array
    the_modes[key] = array
    #p array 
end

checkdup.detect{ |e| checkdup.count(e) > 1 }

tetrachord_base = []

the_modes.each do |key, array|
    tetrachord_arr = []

    array.each_with_index do |st, i|
        if st != array.last
            tetrachord_arr << array[i+1].to_i - st.to_i
        end
    end
    tetrachord_base << tetrachord_arr

end


chroma = ['c', 'cis', 'd', 'ees', 'e', 'f', 'fis', 'g', 'aes', 'a', 'bes', 'b', "c'"]

indx_m = 0

the_modes.each do |key, modes|

    lilypond_file = __dir__ + "/scale_temp"
    output_file = __dir__ + "/modes.ly"

    tetrachord_name = []

    the_name = key.gsub(/gi/, '')

    modes.each_with_index do |mode, i|
        #p mode
        if i==0
            tetrachord_name << chroma[mode.to_i] + '^"' + the_name + '" ' + '_"' + tetrachord_base[indx_m][i].to_s + '"'
        elsif mode!=modes.length
            tetrachord_name << chroma[mode.to_i] + '_"' + tetrachord_base[indx_m][i].to_s + '"'
        end
    end


    print("\\time #{tetrachord_name.length}/4\n")
    print(tetrachord_name.join(" "))
    print("\\break\n")
    #system("lilypond --output=#{__dir__} #{output_file} ")
    #system("rm -r #{output_file}")
    indx_m += 1
end