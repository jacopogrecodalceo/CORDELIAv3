chroma = ["c'", 'cis', 'd', 'ees', 'e', 'f', 'fis', 'g', 'aes', 'a', 'bes', 'b']

base = '101011010101'.split('')

modes = []
modes_rot = []

base.length.times do |r|
    modes_rot << base.rotate(r)
end

modes_rot = modes_rot.uniq
p modes_rot.length

modes_rot.each do |mode|
    the_mode = []

    mode.each_with_index do |n, i|
        if n == '1'
            the_mode << chroma[i]
        end
    end
    the_mode << the_mode[0]
    modes << the_mode.join(' ')
end

print modes.join("\n")