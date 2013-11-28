#!/bin/sh

Prog=`basename $0`

fnUsage() { echo "usage: ${Prog} dir ..." 1>&2; exit 1; }

fnError() { echo "${Prog}: ${1}: ${2}" 1>&2; }

if [ $# -eq 0 ]
	then
		fnUsage
fi

for arg in "$@"
do

	#validate arguments
	#==================
	if [ ! -e "$arg" ]
	then
		fnError "$arg" "No such file or directory"
		continue
	fi

	if [ ! -d "$arg" ]
	then
		fnError "$arg" "Not a directory"
		continue
	fi

	#check if there is only one item in the directory
	if [ $(wcdir "$arg") -eq 1 ]
		then
			filename=`echo "${arg%/}"/*`
			parent_dir=`dirname "$arg"`
			echo "moveout ${filename}"
			echo "moveinto ${parent_dir}" 
			
			if [ -d $filename ]
				then
					mvdir.sh "$filename" "$parent_dir"
				else
					echo "mv -f \"$filename\" \"$parent_dir\""
			fi
	fi
	
done
