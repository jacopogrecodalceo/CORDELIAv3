require_relative __dir__ + "/_path.rb"

out_array                 = Hash.new

out_array["ANAL"]         = File.open($cordelia_out + '_def/anal_def.txt').read
out_array["FREQ"]         = File.open($cordelia_out + '_def/freq_def.txt').read
out_array["OP1"]          = File.open($cordelia_out + '_def/op1_def.txt').read
out_array["TIME"]         = File.open($cordelia_out + '_def/time_def.txt').read
out_array["TIME_FT"]      = File.open($cordelia_out + '_def/timeft_def.txt').read
out_array["2STRINGS"]      = File.open($cordelia_out + '_def/2strings_def.txt').read

out_init                  = File.open($cordelia_out + '_OUT-init.txt').read

out_full_file    = $cordelia_out + '_OUT-full.orc' 

#DELETE OLD .ORC
if  File.exist?(out_full_file) then
    File.delete(out_full_file)
    File.open(out_full_file, 'w')
else
    File.open(out_full_file, 'w')
end

#GENERATE INIT
out_init.each_line do |line|
    full_orc = File.open(out_full_file, "a")
    full_orc.write(line)
    #puts line
    rescue IOError => e
    #some error occur, dir not writable etc.
    ensure
    full_orc.close unless full_orc.nil?
end

#GENERATE FROM DEF
Dir[$cordelia_out + '/*.orc'].each do |each_out_file|

    each_out_name = File.basename(each_out_file, '.orc')

    if each_out_name.start_with?('_')==false then

        out_array.each do |out_type, out_def_text|

            if File.open(each_out_file).read.lines.first.match(/(\w+)/)[0].to_s==out_type then

                out_def_text.each_line do |each_out_line|
                    begin
                        full_orc = File.open(out_full_file, "a")
                        full_orc.write(each_out_line.gsub("---NAME---", each_out_name))
        
                        instr_sig = ";---INSTRUMENT---\n"
                        if each_out_line==instr_sig then
                            each_out_text = File.open(each_out_file).read
                            full_orc.write(each_out_line.gsub(";---INSTRUMENT---", each_out_text))
                        end
        
                        rescue IOError => e
                        #some error occur, dir not writable etc.
                        ensure
                        full_orc.close unless full_orc.nil?
                    end
                end
            end
        end
    end
end
