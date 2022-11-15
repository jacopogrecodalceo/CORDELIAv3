require_relative __dir__ + "/_path.rb"

cordelia_list = __dir__ + "/_cordelia_list/"

if  File.directory?(cordelia_list)
    system("rm -r " + cordelia_list)
    system("mkdir " + cordelia_list)
else
    system("mkdir " + cordelia_list)
end

cordelia_macro = cordelia_list + "cordelia_macro"
cordelia_dyn = cordelia_list + "cordelia_dyn"
cordelia_global = cordelia_list + "cordelia_global"
#cordelia_gen = cordelia_list + "cordelia_gen"
cordelia_instr = cordelia_list + "cordelia_instr"

cordelia_access = cordelia_list + "cordelia_access.rb"

global_i = []
global_k = []
macro = []
dyn = []

File.open($cordelia_full).read.each_line do |line|

    # GLOBAL
    line_giRE = /gi(\w+)/
    if line.match(line_giRE)
        global_i.push(line.match(line_giRE)[1])
    end
    line_gkRE = /gk(\w+)/
    if line.match(line_gkRE)
        global_k.push(line.match(line_gkRE)[1])
    end

end
File.open(cordelia_global, "a").write(global_i.uniq.sort.join("\n"))
File.open(cordelia_global, "a").write(global_k.uniq.sort.join("\n"))
File.open(cordelia_access, "a").write("$cordelia_gi = [" + global_i.uniq.map{ |e| "\"#{e}\"" }.join(", ") + "]\n")
File.open(cordelia_access, "a").write("$cordelia_gk = [" + global_k.uniq.map{ |e| "\"#{e}\"" }.join(", ") + "]\n")

# MACRO
File.open($cordelia_character + "1-MACRO.orc").read.each_line do |line|
    macro_RE = /#define.*?(\w+)/
    if line.match(macro_RE)
        macro.push(line.match(macro_RE)[1])
    end
end
File.open(cordelia_macro, "a").write(macro.uniq.join("\n"))

# DYN
File.open($cordelia_character + "5-DYN.orc").read.each_line do |line|
    dyn_RE = /#define.*?(\w+)/
    if line.match(dyn_RE)
        dyn.push(line.match(dyn_RE)[1])
    end
end
File.open(cordelia_dyn, "a").write(dyn.uniq.join("\n"))
File.open(cordelia_access, "a").write("$cordelia_dyn = [" + dyn.uniq.map{ |e| "\"#{e}\"" }.join(", ") + "]\n")
