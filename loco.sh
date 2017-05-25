#!/bin/bash
#
# loco
#
# Tristan M. Chase
#
# A script to do more with the output of locate.
# A script called row (which see) will work from within this script.
# A script called filetype appends a character to the end of each line 
# (like ls -F).  I would like to merge it inside this script.
#
# Depends: GNU findutils (locate, xargs, updatedb), less, row.sh, filetype.sh

# Dependencies

## System
sys_deps="findutils locate less" #findutils provides xargs

## loco-specific
script_deps="loco row filetype"

# Create a temporary file for output of locate 
outfile=/tmp/loco.$$
touch ${outfile}
export outfile

# Remove temporary file on exit
trap cleanup EXIT

cleanup () {
	rm ${outfile}
}

# This is used only when the pager does not take commands (shell escapes).
awk_statement () {
	obj=`awk '$1 == '$linenum' { print $2 } ' "${outfile}"`
	echo "$cmd $obj"
	$cmd $obj
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

# Harness and organize the output of locate to our temporary file, adding symbols for the file type, line numbers and tabs
locate -i -0 "$1" | xargs -0 filetype |  sed = | sed 'N;s/\n/\t/' > ${outfile}

# This line adds backslash escapes to the filenames containing spaces.
#locate -i -0 "$1" | xargs -0 filetype |  sed = | sed 'N;s/\n/\t/' | sed 's/ /\\ /g' > ${outfile}

# Set to pager of choice.  I would like this eventually to be 
# ncurses-based and self-contaned.
vim -R ${outfile}
#less -M ${outfile}
#pg ${outfile}
#more ${outfile}
#most ${outfile} # See section below.
#w3m ${outfile}

# These lines are here just in case a pager cannot take commands (such as most).
# Uncomment if necessary.
#
#echo -n "Command: "; read cmd
#
#case $cmd in
#    q|quit|"")
#	;;
#    row*)
#	echo "$cmd"
#	$cmd
#	;;
#    *)
#	echo -n "Line No.: "; read linenum 
#	# add test for NULL or not integer in $linenum
#	awk_statement
#	;;
#esac

exit 0
