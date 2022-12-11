require_relative __dir__ + "/_path.rb"

sf_dir = $cordelia_dir + 'soundfont/'

orc_path = sf_dir + '_printsf.orc'
sco_path = sf_dir + '_printsf.sco'
log_path = sf_dir + '_printsf.log'

orc_out_path = sf_dir +'_sf_list.orc'
list_out_path = sf_dir +'_sf_list.txt'

sf_score = File.open(sco_path, 'w')

Dir.glob(sf_dir + '*.sf2') do |f|
    name = File.basename(f)
    score = "i 1 0 0 \"#{name}\"\n"
    sf_score.write(score)
    #p score
    #p command.match(/^(Preset list(?:\n|.)*?)\n$/)
end

sf_score.write('e')
sf_score.close unless sf_score.nil?

cmd = `csound #{orc_path} #{sco_path} --env:SSDIR+=../ -I -O #{log_path}`



sf_instrs = []

orc_out = File.open(orc_out_path, 'w')

File.readlines(log_path).each do |line|
    if line.start_with?('Preset list')
        path = line.match(/.*(".*")/)[1]
        name = path.match(/.*\/(.*)\./)[1]

        string = <<~CS
        gi#{name}   sfload #{path}
		sfpassign #{sf_instrs.length}, gi#{name} 
        CS

        orc_out.write(string + "\n")
    end
    if line.match(/(\d+\).*?)\s*prog/)
        line = line.match(/\d+\)\s+(.*?)\s*prog/)[1].downcase.gsub(' ', '_').gsub(')', '')
        sf_instrs << line
    end
end


string = <<~CS
if strcmp(Sinstr, \"#{sf_instrs.first}\") == 0 then
    ipre = 0
CS
orc_out.write(string + "\n")
sf_instrs[1..-2].each_with_index do |sf, index|
    string = <<~CS
    elseif strcmp(Sinstr, \"#{sf}\") == 0 then
        ipre = #{index+1}
    CS
    orc_out.write(string + "\n")
end
string = <<~CS
elseif strcmp(Sinstr, \"#{sf_instrs.last}\") == 0 then
    ipre = #{sf_instrs.length-1}
endif
CS
orc_out.write(string + "\n")
orc_out.close unless orc_out.nil?



list_out = File.open(list_out_path, 'w')
sf_instrs.each_with_index do |sf, index|
    
    list_out.write("#{index}\t#{sf}\n")

end
list_out.close unless list_out.nil?
