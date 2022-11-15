#!/bin/bash

cd "$(dirname "$0")"
cd ..
cd "./_scripts"

for f in *.rb; do
	if [[ "$f" != _* ]] ;
	then
		ruby "$f" 
	fi
done
