import os
bashCommand = 'pgrep -x "csound" > /dev/null'
is_csound = os.system(bashCommand)

print(iscs)
