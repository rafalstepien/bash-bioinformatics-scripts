#!/bin/bash

longest=0
while read line; do
	if [ $(echo $line | awk '{print $1}') == "deletion" ]; then
		if [ $(echo $line | awk '{print $3}') -gt $longest ]; then
			longest=$(echo $line | awk '{print $3}') 
			longest_coord=$(echo $line | awk '{print $2}')
		fi
	fi
done <$1
echo "LONGEST: $longest, LONGEST COORD: $longest_coord"

