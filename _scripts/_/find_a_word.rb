require_relative File.dirname(File.expand_path(__dir__)) + "/_path.rb"

answer    = ARGV[0]
#p answer
all_files = []

Dir.glob($cordelia_core + '**/*') do |f|
    if not File.directory?(f)
        if File.extname(f) == ".orc" || File.extname(f) == ".csd"
            File.open(f).read.each_line do |line|
                line = line.encode("UTF-8", invalid: :replace)
                if line.match(/#{answer}/)
                    #puts "#{m[0]} was found in " + f
                    all_files.append(f)
                end
            end
        end
    end
end


all_files = all_files.uniq

all_files.each do |a|
    puts a
end