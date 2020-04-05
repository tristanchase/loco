#!/bin/bash
#
# loco
#
# A script to do more with the output of locate.
# A script called row (which see) will work from within this script.
# A script called filetype appends a character to the end of each line
# (like ls -F).  I would like to merge it inside this script.

infile=/tmp/loco.in.$$
touch ${infile}
export infile

outfile=/tmp/loco.$$
touch ${outfile}
export outfile

trap cleanup EXIT

cleanup () {
	rm ${infile} ${outfile}
}

# This is used only when the pager does not take commands (shell escapes).
awk_statement () {
	obj=`awk '$1 == '$linenum' { print $2 } ' "${outfile}"`
	echo "$cmd $obj"
	$cmd $obj
}

count=$(locate -c "$1")

# Test $count for various conditions.

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

locate -i -0 "$1" >> ${infile}
#cd $HOME
#find $HOME -iname "*$1*" -print0 2>/dev/null >> ${infile}
cat ${infile} | xargs -0 filetype | sort | uniq | sed = | sed 'N;s/\n/\t/' > ${outfile}

# Set to pager of choice.  I would like this eventually to be
# ncurses-based and self-contaned.

less -M ${outfile}
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
