#!/bin/bash

## ----------------------------------------------------------- a -----------------------------------------
echo "--------TOTAL CNV's NUMBER IN TWO FILES--------"
first=$(cat $1 | wc -l)
second=$(cat $2 | wc -l)
let CNV_total=$first+$second
echo "FILE1: $first"

## ----------------------------------------------------------- b -----------------------------------------
echo "--------TOTAL DELETIONS AND DUPLICATIONS NUMBER--------"
total_deletions=0
total_duplications=0
for line in $(awk '{print $1}' $1):
do
	if [ $line == "deletion" ]
	then
		let "total_deletions++"
	elif [ $line == "duplication" ]
	then
		let "total_duplications++"
	fi
done
printf "DELETIONS: $total_deletions\nDUPLICATIONS: $total_duplications\n"

# ----------------------------------------------------------- c ------------------------------------------
echo "--------CHROMOSME 3 DELETIONS AND DUPLICATIONS NUMBER--------"
chr3_deletions=0
chr3_duplications=0
while read line; do
	str=$(echo $line | awk '{print $2}' | cut -d ":" -f 1)
	if [ $str == "chr3" ]; then
		type="$(echo $line | awk '{print $1}')"
		if [ $type == "deletion" ]
		then
			let "chr3_deletions++"
		elif [ $type == "duplication" ]
		then
			let "chr3_duplications++"
		fi
	fi
done <$1
printf "CHR3_DELETIONS: $chr3_deletions\nCHR3_DUPLICATIONS: $chr3_duplications\n"

# ----------------------------------------------------------- d ------------------------------------------
echo "--------PERCENT OF DUPLICATIONS--------"

totals=$((total_duplications + total_deletions))
percent=$(echo "scale=2; $total_duplications/$totals" | bc) 
echo "$percent"

# ------------------------------------------------------------ e -----------------------------------------
echo "--------MEAN LENGTH OF ALL POLYMORPHISMS--------"
total_pol_len=0
while read line; do
	total_pol_len=$(($total_pol_len+$(echo $line | awk '{print $3}')))
done <$1
mean_pol=$(echo "scale=2; $total_pol_len/$(cat $1 | wc -l)" | bc)
echo "$mean_pol"

# ------------------------------------------------------------ f -----------------------------------------
echo "--------MEAN DUPLICATION LENGTH--------"
total_dup_len=0
while read line; do
	if [ $(echo $line | awk '{print $1}') == "duplication" ]; then
		total_dup_len=$(($total_dup_len+$(echo $line | awk '{print $3}')))
	fi
done <$1
mean_dup=$(echo "scale=2; $total_dup_len/$total_duplications" | bc)
echo "$mean_dup"

# ------------------------------------------------------------ g -----------------------------------------
echo "--------MAX DUPLICATION LENGTH--------"
max_len=0
while read line; do
	if [ $(echo $line | awk '{print $1}') == "duplication" ]; then
		if [ $(echo $line | awk '{print $3}') -gt $max_len ]; then
			max_len=$(echo $line | awk '{print $3}') 
		fi
	fi
done <$1
echo $max_len

# ------------------------------------------------------------ h -----------------------------------------
echo "--------MIN DELETION LENGTH--------"
min_len=9999999999
while read line; do
	if [ $(echo $line | awk '{print $1}') == "deletion" ]; then
		if [ $(echo $line | awk '{print $3}') -lt $min_len ]; then
			min_len=$(echo $line | awk '{print $3}')
		fi
	fi
done <$1
echo $min_len
