import glob, os

dir_dest = '/Users/j/Documents/PROJECTs/CORDELIA/_lists/'

lists = [
    '/Users/j/Documents/PROJECTs/CORDELIA/_core/3-body/2-OP/rhythm',
    '/Users/j/Documents/PROJECTs/CORDELIA/_core/3-body/3-OUT'
    ]


for each_dir in lists:
    name_dir = os.path.basename(each_dir).split('.')[0]
    outs = []
    for each_file in glob.glob(each_dir + '/*.orc'):
        name = os.path.basename(each_file).split('.')[0]
        if not name.startswith('_'):
            outs.append(name)

    with open(dir_dest + 'list_' + name_dir, 'w') as f:
        outs.sort() 
        f.write('\n'.join(outs))
