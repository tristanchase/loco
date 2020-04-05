#!/bin/bash
set -e
#
# loco
#
# Tristan M. Chase
#
# A script to do more with the output of *locate*.
# A script called *row* (which see) will work from within this script.
# A script called *filetype* appends a character to the end of each line
# (like ls -F).  I would like to merge it inside this script.
#
# Depends: GNU findutils ([m]locate, xargs, updatedb), vim, less, wget, row.sh, filetype.sh

# Dependencies

## System
sys_deps="findutils [m]locate less wget vim" #findutils provides xargs

## loco-specific (my scripts)
script_deps="loco row filetype"

# Create a temporary file for output of locate
tempfile=$HOME/tmp
outfile=$tempfile/loco.$$
mkdir -p $tempfile
touch $outfile
export outfile

# Remove temporary file on exit
trap cleanup EXIT

cleanup () {
	rm $outfile
}

# Some searches will have a large amount of output. Ask user if they want to continue with a file larger than 10,000 lines.
count=$(locate -c "$1")

# [Handle warning about locate database being over 8 days old]

if [ $count -eq "0" ]; then
	echo -n $0": Search term not found: "$1
	exit
fi

if [ $count -gt "10000" ]; then
	echo -n "File will have "$count" lines.  Do you wish to continue?(y/N): "; read response

	case $response in
		y|Y)
			echo "Processing..."
			;;
		*)
			echo "Aborting..."
			sleep 0.5
			exit
			;;
	esac
fi

# Harness and organize the output of *locate* to our temporary file, adding symbols for the file type, line numbers and tabs, and escaping spaces (*filetype* handles escaping spaces now)

locate -i -0 "$1" | xargs -0 filetype | sed = | sed 'N;s/\n/\t/' > $outfile

# Set to pager of choice.

#less -M $outfile
vim $outfile # I really like this because you can open the files from their path names by using g[fFx]
#pg $outfile
#more $outfile
#w3m $outfile

exit 0
