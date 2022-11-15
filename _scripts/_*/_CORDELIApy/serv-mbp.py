import sys
import ctcsound

cs = ctcsound.Csound()
result = cs.compile_(sys.argv)
if result == 0:
    while cs.performKsmps() == 0:
        pass
cs.cleanup()
del cs
sys.exit(result)