jacques_scala_dir      = '/Users/j/Documents/PROJECTs/_METHOD/_microtonality/scala_pack/jacques/'

3.upto(72) do |i|
    edo = File.open(jacques_scala_dir + 'edo' + i.to_s + '.scl', 'w')
    edo.write("!\n!by jacques\n")
    description = 'edo ' + i.to_s
    edo.write(description)
    edo.write("\n")
    degrees = i.to_s
    edo.write(degrees)
    edo.write("\n!\n")
    1.upto(i-1) do |x|
        ratio = (1200/i.to_f)*x
        edo.write(ratio.to_s)
        edo.write("\n")
        p ratio
    end
    edo.write('2/1')
    edo.write("\n")
    p '---'
end

3.upto(72) do |i|
    edo = File.open(jacques_scala_dir + 'edolin' + i.to_s + '.scl', 'w')
    edo.write("!\n!by jacques\n")
    description = 'edolin ' + i.to_s
    edo.write(description)
    edo.write("\n")
    degrees = i.to_s
    edo.write(degrees)
    edo.write("\n!\n")
    1.upto(i-1) do |x|
        edo.write("1+(#{x}/#{i})")
        edo.write("\n")
    end
    edo.write('2/1')
    edo.write("\n")
end
