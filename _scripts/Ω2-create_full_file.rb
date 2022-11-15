require_relative __dir__ + "/_path.rb"

list = File.open($cordelia_include).map(&:chomp)

if  File.file?($cordelia_full) then
    File.delete($cordelia_full)
    File.open($cordelia_full, 'w')
else
    File.open($cordelia_full, 'w')
end

list.each do |path_list_line|

    path_list_line = path_list_line.gsub('#include "', '')
    path_list_line = path_list_line.gsub('"', '')
    #path_list_line = path_list_line[1..-1]
    #puts path_list_line
    p path_list_line
    File.readlines(path_list_line).each do |for_each_path_line|
        File.write($cordelia_full, for_each_path_line, File.size($cordelia_full), mode: 'a')
    end

    File.write($cordelia_full, "\n\n\n;--- ||| --- ||| ---\n\n", File.size($cordelia_full), mode: 'a')

end