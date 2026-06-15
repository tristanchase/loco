#!/usr/bin/env bash

#-----------------------------------
# Usage Section

#<usage>
#//Usage: template.21168 [ {-d|--debug} ] [ {-h|--help} | <options>] [<arguments>]
#//Description: This is a template file.
#//Examples: template.21168 foo; template.21168 --debug bar
#//Options:
#//	-d --debug	Enable debug mode
#//	-h --help	Display this help message
#</usage>

#<created>
# Created: 2026-06-15T03:34:02-04:00
# Tristan M. Chase <tristan.m.chase@gmail.com>
#</created>

#<depends>
# Depends on:
#  list
#  of
#  dependencies
#</depends>

#-----------------------------------
# TODO Section

#<todo>
# TODO
# * Rename $variables to "${_variables}" /\$\w+/s+1 @v vEl,{n
# * Check that _variable="variable definition" (make sure it's in quotes)
# * Update usage, description, and options section
# * Update dependencies section

# DONE
# + Insert script
# + Clean up stray ;'s
# + Modify command substitution to "$(this_style)"
# + Rename function_name() to function __function_name__ /\w+\(\)

#</todo>

#-----------------------------------
# License Section

#<license>
# Put license here
#</license>

#-----------------------------------
# Runtime Section

#<main>
# Initialize variables
#_temp="file.$$"
_tempfile=$HOME/tmp
_outfile=$_tempfile/loco.$$

# List of temp files to clean up on exit (put last)
_tempfiles=("${_outfile}")

# Put main script here
function __main_script__ {

# Create a temporary file for output of locate
mkdir -p $_tempfile
touch $_outfile
export _outfile

# Some searches will have a large amount of output. Ask user if they want to continue with a file larger than 10,000 lines.
_count=$(locate -c "${_name:-}")

# [Handle warning about locate database being over 8 days old]

if [[ $_count -eq "0" ]]; then
	echo $0": Search term not found: ""${_name}"
	exit
fi

if [[ $_count -gt "10000" ]]; then
	echo -n "File will have "$_count" lines.  Do you wish to continue?(y/N): "; read _response

	case $_response in
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

locate -i -0 "${_name}" | xargs -0 filetype | sed = | sed 'N;s/\n/\t/' > $_outfile

# Set to pager of choice.

#less -M $_outfile
vim $_outfile # I really like this because you can open the files from their path names by using g[fFx]
#pg $_outfile
#more $_outfile
#w3m $_outfile

} #end __main_script__
#</main>

#-----------------------------------
# Local functions

#<functions>
function __local_cleanup__ {
	:
}
#</functions>

#-----------------------------------
# Source helper functions
for _helper_file in functions colors git-prompt; do
	if [[ ! -e ${HOME}/."${_helper_file}".sh ]]; then
		printf "%b\n" "Downloading missing script file "${_helper_file}".sh..."
		sleep 1
		wget -nv -P ${HOME} https://raw.githubusercontent.com/tristanchase/dotfiles/main/"${_helper_file}".sh
		mv ${HOME}/"${_helper_file}".sh ${HOME}/."${_helper_file}".sh
	fi
done

source ${HOME}/.functions.sh

#-----------------------------------
# Get some basic options
# TODO Make this more robust
#<options>
shopt -s extglob
case "${1:-}" in
	(-d|--debug) __debugger__ ;;
	(-h|--help) __usage__ ;;
	(-*|--*) printf "%b\n" "Option \""${1:-}"\" not recognized." ; __usage__ ;;
	(*) _name="${1:-}"
esac
shopt -u extglob
#</options>

#-----------------------------------
# Bash settings
# Same as set -euE -o pipefail
#<settings>
#set -o errexit
#set -o nounset
#set -o errtrace
#set -o pipefail
IFS=$'\n\t'
#</settings>

#-----------------------------------
# Main Script Wrapper
if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
	trap __traperr__ ERR
	trap __ctrl_c__ INT
	trap __cleanup__ EXIT

	__main_script__ "${_name}"


fi

exit 0
