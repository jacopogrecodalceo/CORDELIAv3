require_relative __dir__ + "/_path.rb"

list_txt = $cordelia_dir + '_scripts/_cmd/_list_instr.txt'
temp_tex = $cordelia_dir + '_scripts/_cmd/tex_temp-list_instr.txt'
dest_tex = $cordelia_dir + 'cordelia_instr.tex'

#FUNCTIONs
def get_csound_comment(orc)
	if not File.directory?(orc)
		first_line = File.open(orc) {|f| f.readline}
		if first_line.start_with?(';')
			return first_line
		else
			return "---"
		end
	else
		return "---"
	end
end

tex = File.open(dest_tex, 'w')

#INSTRs
all_instr = {}

Dir.glob($cordelia_instr + '*.orc') do |f|
	if not File.directory?(f)
		name = File.basename(f, '.orc')
		if not name.start_with?('_')
			all_instr[name] = get_csound_comment(f)
			#if not first_line.nil?
			#  all_instr.push(first_line)
			#end
		end
	end
end

#SAMPs
all_samp = {}

Dir.glob($cordelia_samp + '*.wav') do |f|
  if not File.directory?(f)
	name = File.basename(f, '.wav')
	if not name.start_with?('_')
		all_samp[name] = get_csound_comment(f)
	end
  end
end

#DIRs
all_dir = {}

Dir.glob($cordelia_samp + '*') do |f|
  if File.directory?(f)
	  name = File.basename(f)
	  if not name.start_with?('_')
		all_dir[name] = get_csound_comment(f)
	end
  end
end

ref_instr = /\s+---INSTRs---/
ref_samp = /\s+---SAMPs---/
ref_dir = /\s+---DIRs---/

ref_instr_len = /\s+---INSTRs_LEN---/
ref_samp_len = /\s+---SAMPs_LEN---/
ref_dir_len = /\s+---DIRs_LEN---/

File.readlines(temp_tex).each do |line|

	case line
	when ref_instr
		string = ''

=begin 		
		all_instr.sort.each_slice(2) do |name| 
			if name[1]
				string << name[0] + ' & ' + name[1] + " " + '\cr' + "\n"
			else
				string << name[0] + ' & ' + "---" + " " + '\cr' + "\n"
			end
		end
=end
		all_instr.sort.each do |name, comment|
			string << name + ' & ' + comment + ' \cr' + "\n"
		end
		tex.write(line.gsub(ref_instr, string))
	
	when ref_instr_len
		tex.write(line.gsub(ref_instr_len, all_instr.length.to_s))

	when ref_samp
		string = ''
=begin 		
		all_samp.sort.each_slice(2) do |name| 
			if name[1]
				string << name[0] + ' & ' + name[1] + " " + '\cr' + "\n"
			else
				string << name[0] + ' & ' + "---" + " " + '\cr' + "\n"
			end
		end
=end
		all_samp.sort.each do |name, comment|
			string << name + ' & ' + comment + ' \cr' + "\n"
		end
		tex.write(line.gsub(ref_samp, string))
	
	when ref_samp_len
		tex.write(line.gsub(ref_samp_len, all_samp.length.to_s))
	
	when ref_dir
		string = ''
=begin 		
		all_dir.sort.each_slice(2) do |name| 
			if name[1]
				string << name[0] + ' & ' + name[1] + " " + '\cr' + "\n"
			else
				string << name[0] + ' & ' + "---" + " " + '\cr' + "\n"
			end
		end
=end
		all_dir.sort.each do |name, comment|
			string << name + ' & ' + comment + ' \cr' + "\n"
		end
		tex.write(line.gsub(ref_dir, string))
	
	when ref_dir_len
		tex.write(line.gsub(ref_dir_len, all_dir.length.to_s))

	ref_samp_len
	else
		tex.write(line)

	end
end

tex.close unless tex.nil?

system("pdflatex -output-directory=#{$cordelia_dir} #{dest_tex} ")

File.delete($cordelia_dir + 'cordelia_instr.tex')
File.delete($cordelia_dir + 'cordelia_instr.log')
File.delete($cordelia_dir + 'cordelia_instr.aux')

#GENERATE LIST TXT OF ALL INSTRUMENTs
everything = []

Dir.glob($cordelia_instr + '**/*.orc') do |f|
    if not File.directory?(f)
        name = File.basename(f, '.orc')
        if not name.start_with?('_')
            everything.push(name)
        end
    end
end

list = File.open(list_txt, 'w')
everything.sort.each do |name| 
	list.write(name + "\n")
end