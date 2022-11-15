require_relative __dir__ + "/_path.rb"

cordelia_sampleDEF      = File.open($cordelia_instr + '_sample/_sampleDEF.txt').read
cordelia_dirDEF       = File.open($cordelia_instr + '_sample/_dirDEF.txt').read

cordelia_instr_sample       = $cordelia_instr + '_sample/'

#DELETE ALL .ORC
Dir[cordelia_instr_sample + '*.orc'].each do |file|
    File.delete(file)
end

#GENERATE FROM SAMPLES
Dir[$cordelia_samp + '*'].each do |f|

    #CHECK IF IT IS A DIRECTORY
    if File.directory?(f)

        name = File.basename(f)
        orc_file   = cordelia_instr_sample + name + ".orc"

        orc = File.open(orc_file, 'a')

        sonvs_array = []

        Dir[f + '/*.wav'].each do |wav_path|

            #SUB "-" FOR THE CSOUND NAME INTERDICTION
            wav_name = File.basename(wav_path, '.wav').gsub("-", "_")

            orc.write('gS' + wav_name + "_file \t init \"" + wav_path + "\"\n")
            orc.write('gi' + wav_name + "_1\t\t ftgen 0, 0, 0, 1, gS" + wav_name + "_file, 0, 0, 1\n")
            orc.write('gi' + wav_name + "_2\t\t ftgen 0, 0, 0, 1, gS" + wav_name + "_file, 0, 0, 2\n")
            orc.write(";-------\n")

            sonvs_array << 'gi' + wav_name + '_1'
            sonvs_array << 'gi' + wav_name + '_2'

        end

        array_name = 'gi' + name + '_sonvs'
        orc.write(array_name + "[]\t\t\tfillarray\t") 

        sonvs_array.each do |i|
            if  sonvs_array.index(i)<sonvs_array.length-1 then
                orc.write(i + ', ')
            else
                orc.write(i)
            end
        end

        orc.write(";-------\n")

        cordelia_dirDEF.each_line do |line|
            orc.write(line.gsub("---NAME---", name).gsub("---ARRAY---", array_name))
        end

        #CLOSE THE FILE
        orc.close
        
    #OR CHECK IF IT IS A WAV - OTHERS EXTENTIONS ARE DEAD
    elsif File.extname(f) == ".wav"

        nchnls = `soxi -c #{f}`.chomp.to_i
        name = File.basename(f, '.wav')
        orc_file   = cordelia_instr_sample + name + ".orc"

        orc = File.open(orc_file, 'a')

        #APPEND THE gS & gi NCHNLS
        orc.write('gS' + name + "_file \t\t init \"" + f + "\"\n")
        orc.write('gi' + name + "_chs \t\t init " + nchnls.to_s + "\n")
        orc.write(";-------\n")

        #APPEND THE gi FILE FOR EACH CHANNEL
        nchnls.times do |i| 
            ch = (i + 1).to_s
            orc.write('gi' + name + "_" + ch + "\t\t ftgen 0, 0, 0, 1, gS" + name + "_file, 0, 0, " + ch + "\n")
        end
        orc.write(";-------\n")

        #APPEND THE DEF FILE
        cordelia_sampleDEF.each_line do |line|
            orc.write(line.gsub("---NAME---", name))
        end

        #CLOSE THE FILE
        orc.close
    
    end
end
