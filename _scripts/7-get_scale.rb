require_relative __dir__ + "/_path.rb"

dir_with_all_scala_dir      = '/Users/j/Documents/PROJECTs/_METHOD/_microtonality/scala_pack/'
#dir_with_all_scala_dir = '/Users/j/Downloads/No Octaves/'
cordelia_scale_file         = $cordelia_head + 'SCALE-SCL.orc'
cordelia_scale_file7         = $cordelia_head + 'SCALE-SCL7.orc'
cordelia_scale_file12         = $cordelia_head + 'SCALE-SCL12.orc'

cordelia_file_open = File.open(cordelia_scale_file, 'w')
cordelia_file_open7 = File.open(cordelia_scale_file7, 'w')
cordelia_file_open12 = File.open(cordelia_scale_file12, 'w')

#               			numgrades		interval		basefreq		basekey			values
#giScale ftgen 0, 0, 0, -2,	7,				2,				A4,				69,				256/243, 32/27, 4/3, 3/2, 128/81, 16/9, 2/1

ftgen_format = []

replacements = {
' ' => '_',
'#' => 'dies',
'-' => '_',
'+' => '_',
'(' => '_',
')' => '_',
'[' => '_',
']' => '_'
}

Dir[dir_with_all_scala_dir + '**/*.scl'].each do |f|

    name = 'gi' + File.basename(f, '.scl').gsub(Regexp.union(replacements.keys), replacements)

    f_open = File.open(f).read
    index_line = 0
    lines = []
    f_open.each_line do |line|
        #avoid comment 
        if not line.lstrip.start_with?('!')
            lines[index_line] = line.lstrip
            index_line += 1
        end
    end

    #first line is description
    if lines[0] != ''
        description = ';' + lines[0]
    else
        #p f
        description = ';' + "---\n"
    end
    
    #second line is degrees
    degrees = lines[1][/(.*?)($|\s.*)/, 1]

    basefreq = 'A4'
    basekey = '69' #'ntom("4A")'

    tuning_value = []
    add_me = true
    lines[2..-1].each do |value|

        value = value[/(.*?)($|\s.*)/, 1]

        if value.include?('.')
            res = 2 ** (value.to_f/1200)
        else
            res = value
            if res[/\d+\/(\d+)/, 1].to_i > 10 ** 10
                p 'Csound cannot read this'
                add_me = false
            end
        end
       # p res
        tuning_value << res.to_s
    end

    interval = tuning_value.last

    if degrees.to_i != tuning_value.length
        p 'WARNING --- degrees are different from the tuning values'
    end

    base_val = '1'

    if add_me
        case degrees.to_i
        when 7
            cordelia_file_open7.write(description + name + "\t\t\t\t\tftgen 0, 0, 0, -2, " + degrees + ', ' + interval + ', ' + basefreq + ', ' + basekey + ', ' + base_val + ', ' + tuning_value.join(', ') + "\n")
            cordelia_file_open7.write(name + '_degs' + ' = ' + degrees + "\n")
            cordelia_file_open7.write("\n")
        when 12
            cordelia_file_open12.write(description + name + "\t\t\t\t\tftgen 0, 0, 0, -2, " + degrees + ', ' + interval + ', ' + basefreq + ', ' + basekey + ', ' + base_val + ', ' + tuning_value.join(', ') + "\n")
            cordelia_file_open12.write(name + '_degs' + ' = ' + degrees + "\n")
            cordelia_file_open12.write("\n")
        else
            cordelia_file_open.write(description + name + "\t\t\t\t\tftgen 0, 0, 0, -2, " + degrees + ', ' + interval + ', ' + basefreq + ', ' + basekey + ', ' + base_val + ', ' + tuning_value.join(', ') + "\n")
            cordelia_file_open.write(name + '_degs' + ' = ' + degrees + "\n")
            cordelia_file_open.write("\n")
        end
    end
end

