#!/bin/bash


while read file_1; do
	while read file_2; do
		line_1=$(echo $file_1 | awk '{print $1, $2, $3}')
		line_2=$(echo $file_2 | awk '{print $1, $2, $3}')
		if [ "$line_1" == "$line_2" ] && [ "$(echo $line_1 | awk '{print $1}')" == "duplication" ]; then
			echo $line_1 >> "common_duplications.txt"
		fi
	done <$2
done <$1

 
while read file_1; do
#	while read file_2; do
#		line_1=$(echo $file_1 | awk '{print $1, $2, $3}')
#		line_2=$(echo $file_2 | awk '{print $1, $2, $3}')
#		if [ "$line_1" == "$line_2" ] && [ "$(echo $line_1 | awk '{print $1}')" == "deletion" ]; then
#			echo $line_1 >> "common_deletions.txt"
#		fi
#	done <$2
#done <$1


