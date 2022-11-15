require_relative __dir__ + "/_path.rb"
orc_array = []

section = '1-character'
Dir.glob($cordelia_core + section + '/*.orc') do |f|
    f = f.match(/_core.*/)[0]
    orc_array.push(f)
end

section = '2-head'
Dir.glob($cordelia_core + section + '/**/*.orc') do |f|
    f = f.match(/_core.*/)[0]
    orc_array.push(f)
end

section = '3-body'
Dir.glob($cordelia_core + section + '/**/*.orc') do |f|

    dir_name = File.basename(File.dirname(f))

    #exception
    if dir_name == '3-OUT'
        if f.match(/full/)
            f = f.match(/_core.*/)[0]
            orc_array.push(f)
        end
    else
        f = f.match(/_core.*/)[0]
        orc_array.push(f)
    end

end

orc_array = orc_array.sort

File.open($cordelia_include, 'w')
orc_include = File.open($cordelia_include, 'a')

orc_array.each do |line|
    append = '#includestr "$JOIN($CORDELIA_PATH\'' + line + ')"' + "\n"
    orc_include.write(append)
end

orc_include.close

File.open($cordelia_livecoding, 'w')
orc_livecoding = File.open($cordelia_livecoding, 'a')

File.readlines($cordelia_setting).each do |line|
    orc_livecoding.write(line)
end

File.readlines($cordelia_include).each do |line|
    orc_livecoding.write(line)
end

orc_livecoding.write("\n</CsInstruments>\n</CsoundSynthesizer>")

orc_livecoding.close
