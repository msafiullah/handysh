#!/bin/bash

Prog=`basename $0`

fnUsage() { echo "usage: ${Prog} element ..." 1>&2; exit 1; }

declare -a ELEMENTS=()

if [[ -t 0 ]] || [[ $# -gt 0 ]]
then
	# read from terminal stdin
	for arg in "$@"
	do
		ELEMENTS+=("$arg")
	done
else
	# read from file stdin
  while read -r line ; do
		ELEMENTS+=("$line")
  done
fi

if [[ -z $ELEMENTS ]]
then
  fnUsage
fi

array=`printf "%s, " ${ELEMENTS[@]} | sed 's/, $//'`
echo "[$array]"