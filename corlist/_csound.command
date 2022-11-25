#!/bin/bash

csound --devices

echo "NUM DEVICE?"
read DEV

csound "$(dirname "$0")"/_csound.csd -odac$DEV ;

exit